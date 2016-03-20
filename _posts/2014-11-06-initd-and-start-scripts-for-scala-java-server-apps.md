---
layout: post
title:  Init.d and Start Scripts for Scala/Java Server Apps
---

I like to use two scripts for running and managing the lifecycle of server applications: a `start` script and an `init.d` script.

The `start` script does the actual job of launching the application. In the case of Scala or Java it fires up the JVM and adds all the necessary arguments (memory, GC, etc.). It should also provide the basic configuration for your application: main entry point, classpath, config file, logging config file, etc. You should be able to easily run the application by simply launching the `start` script; however this is not something you're most likely ever do to – for that you have the `init.d` script.

The `init.d` script is used to control the application's process state and lifecycle: start and stop it, check whether it's running, and restart it if necessary. It should also manage the application's `pid` file. It could be used for event monitoring, like letting [an external system know](https://docs.newrelic.com/docs/agents/java-agent/instrumentation/recording-deployments-java-agent) that the service's state has changed. The `init.d` script doesn't interact with the app itself, but rather with its `start` script. This allows you to decouple application specific configuration from the lifecycle and state of the operating system process.

Below are the two scripts that I use. These are actually [jinja2](http://jinja.pocoo.org/) templates that I use in conjunction with [Ansible](http://www.ansible.com/home) to deploy [multiple services](https://github.com/orrsella/scala-e2e-testing). They assume that your application is deployed as a thin jar in `BIN_DIR`, with all of its dependencies in the same directory (as can be achieved by using [standalone Ivy](http://ant.apache.org/ivy/history/latest-milestone/standalone.html), [Maven](http://maven.apache.org/) and its `dependency:get` [plugin](http://maven.apache.org/plugins/maven-dependency-plugin/), or simply by exploding a fat jar downloaded on the server).

### Start Script

{% highlight bash %}
{% raw %}
#!/bin/bash

MAIN_CLASS={{ main_class }}
APP_CONFIG={{ app_config }}
LOG_CONFIG={{ log_config }}
BIN_DIR={{ bin_dir }}

# ***********************************************
# ***********************************************

ARGS="-Dconfig.file=${APP_CONFIG} -Dlogback.configurationFile=${LOG_CONFIG}"

exec java $ARGS -cp "$BIN_DIR/*" $MAIN_CLASS
{% endraw %}
{% endhighlight %}

(Gist found [here](https://gist.github.com/orrsella/e6b74108270fe6015aac))

(For application configuration I'm using [Typesafe config](https://github.com/typesafehub/config) with the `config.file` parameter, and [Logback](http://logback.qos.ch/) with the `logback.configurationFile` parameter for logging, but that shouldn't matter at all. Customize as needed.)

I usually like to place the `start` script right next to the `BIN_DIR` in a `script` directory. Here's my typical structure:

{% highlight bash %}
$ tree /opt/myapp
├── bin
│   ├── com.example.myapp-1.0.0.jar
│   └── ... # all your dependency jars
├── conf
│   ├── application.conf
│   └── logback.xml
└── script
    └── start
{% endhighlight %}

All of these pieces are put in-place by the [CM tool](http://www.ansible.com/home). Launching the `start` script will run the application interactively in the logged in session, displaying `stdout` in the terminal. This could be useful for debugging, but should generally be avoided – you should start the app from the `init.d` script.

### Init.d Script

{% highlight bash %}
{% raw %}
#!/bin/bash

START_SCRIPT={{ start_script }}
PID_FILE={{ pid_file }}

# ***********************************************
# ***********************************************

ARGS="" # optional start script arguments
DAEMON=$START_SCRIPT

# colors
red='\e[0;31m'
green='\e[0;32m'
yellow='\e[0;33m'
reset='\e[0m'

echoRed() { echo -e "${red}$1${reset}"; }
echoGreen() { echo -e "${green}$1${reset}"; }
echoYellow() { echo -e "${yellow}$1${reset}"; }

start() {
  PID=`$DAEMON $ARGS > /dev/null 2>&1 & echo $!`
}

case "$1" in
start)
    if [ -f $PID_FILE ]; then
        PID=`cat $PID_FILE`
        if [ -z "`ps axf | grep -w ${PID} | grep -v grep`" ]; then
            start
        else
            echoYellow "Already running [$PID]"
            exit 0
        fi
    else
        start
    fi

    if [ -z $PID ]; then
        echoRed "Failed starting"
        exit 3
    else
        echo $PID > $PID_FILE
        echoGreen "Started [$PID]"
        exit 0
    fi
;;

status)
    if [ -f $PID_FILE ]; then
        PID=`cat $PID_FILE`
        if [ -z "`ps axf | grep -w ${PID} | grep -v grep`" ]; then
            echoRed "Not running (process dead but pidfile exists)"
            exit 1
        else
            echoGreen "Running [$PID]"
            exit 0
        fi
    else
        echoRed "Not running"
        exit 3
    fi
;;

stop)
    if [ -f $PID_FILE ]; then
        PID=`cat $PID_FILE`
        if [ -z "`ps axf | grep -w ${PID} | grep -v grep`" ]; then
            echoRed "Not running (process dead but pidfile exists)"
            exit 1
        else
            PID=`cat $PID_FILE`
            kill -HUP $PID
            echoGreen "Stopped [$PID]"
            rm -f $PID_FILE
            exit 0
        fi
    else
        echoRed "Not running (pid not found)"
        exit 3
    fi
;;

restart)
    $0 stop
    $0 start
;;

*)
    echo "Usage: $0 {status|start|stop|restart}"
    exit 1
esac
{% endraw %}
{% endhighlight %}

(Gist found [here](https://gist.github.com/orrsella/6ccaa03886bc857e00e4))

This script is a lot more complicated. Let's break it down:

* You would normally put this script in `/etc/init.d/myapp`.
* The script accepts the following commands: `status`, `start`, `stop` and `restart`.
* `START_SCRIPT` should be the location of the `start` script.
* `PID_FILE` is where you want your `pid` file saved, usually: `/var/run/myapp.pid`.
* The script is intelligent enough not to let you start two instances of the app if it's already running.
* Standard script [exit codes](http://refspecs.linuxbase.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/iniscrptact.html):
  * `0` – program is running or service is OK
  * `1` – program is dead and /var/run pid file exists
  * `3` – program is not running
* Running each of the commands will output a colored status message with the result. For example:

{% highlight bash %}
$ sudo /etc/init.d/myapp start
Started [27882] # <= trust me, this is green
{% endhighlight %}

The combination of these two scripts offers a robust way to manage the lifecycle of the app. I think they provide a good separation of concerns, and allow the `init.d` script to be reusable for multiple types of applications, provided that they have a `start` script. Only the `start` script intimately knows the app and that it's is JVM-based, and it does not bother itself with environment concerns like process ids and such.

If you're interested in the rest of the deployment code I use for such server apps you can check out [this Ansible](https://github.com/orrsella/scala-e2e-testing/tree/master/ansible/roles/memento-finatra) role.

Have a comment or a suggestion for a better way to do any of this? [Please let me know!](https://twitter.com/orrsella)
