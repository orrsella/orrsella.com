---
layout: post
title:  HTTP Request Diagnostics With cURL
---

I had recently needed to diagnose some HTTP requests to understand where time was spent, download speeds, etc. [This great post](https://josephscott.org/archives/2011/10/timing-details-with-curl/) by Joseph Scott shows how to get timing info for a request using curl. I expanded on it by adding all available curl `--write-out` variables and HTTP headers (sample response below).

Here's what you need to do:

* Create a file for the curl formatting (named `curl-format` in our case).
* Add the following to `curl-format`:

{% highlight text %}
\n\n
      content_type: %{content_type}\n
filename_effective: %{filename_effective}\n
    ftp_entry_path: %{ftp_entry_path}\n
         http_code: %{http_code}\n
      http_connect: %{http_connect}\n
          local_ip: %{local_ip}\n
        local_port: %{local_port}\n
      num_connects: %{num_connects}\n
     num_redirects: %{num_redirects}\n
      redirect_url: %{redirect_url}\n
         remote_ip: %{remote_ip}\n
       remote_port: %{remote_port}\n
     size_download: %{size_download}\n
       size_header: %{size_header}\n
      size_request: %{size_request}\n
       size_upload: %{size_upload}\n
    speed_download: %{speed_download}\n
      speed_upload: %{speed_upload}\n
 ssl_verify_result: %{ssl_verify_result}\n
     url_effective: %{url_effective}\n
\n\n
   time_namelookup: %{time_namelookup}\n
      time_connect: %{time_connect}\n
   time_appconnect: %{time_appconnect}\n
  time_pretransfer: %{time_pretransfer}\n
     time_redirect: %{time_redirect}\n
time_starttransfer: %{time_starttransfer}\n
                   -------\n
        time_total: %{time_total}\n
\n
{% endhighlight %}


Then make a request with the format file:

{% highlight bash %}
$ curl -v -w "@curl-format" -o /dev/null -s http://www.orrsella.com
{% endhighlight %}

Example response:

{% highlight text %}
* Adding handle: conn: 0x7f8b3b803600
* Adding handle: send: 0
* Adding handle: recv: 0
* Curl_addHandleToPipeline: length: 1
* - Conn 0 (0x7f8b3b803600) send_pipe: 1, recv_pipe: 0
* About to connect() to www.orrsella.com port 80 (#0)
*   Trying 104.131.121.209...
* Connected to www.orrsella.com (104.131.121.209) port 80 (#0)
> GET / HTTP/1.1
> User-Agent: curl/7.30.0
> Host: www.orrsella.com
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
* Server nginx/1.4.6 (Ubuntu) is not blacklisted
< Server: nginx/1.4.6 (Ubuntu)
< Date: Mon, 06 Oct 2014 13:42:42 GMT
< Content-Type: text/html
< Content-Length: 193
< Connection: keep-alive
< Location: http://orrsella.com/
<
{ [data not shown]
* Connection #0 to host www.orrsella.com left intact


      content_type: text/html
filename_effective: /dev/null
    ftp_entry_path:
         http_code: 301
      http_connect: 000
          local_ip: 192.168.28.249
        local_port: 58388
      num_connects: 1
     num_redirects: 0
      redirect_url: http://orrsella.com/
         remote_ip: 104.131.121.209
       remote_port: 80
     size_download: 193
       size_header: 203
      size_request: 80
       size_upload: 0
    speed_download: 689.000
      speed_upload: 0.000
 ssl_verify_result: 0
     url_effective: http://www.orrsella.com/


   time_namelookup: 0.001
      time_connect: 0.141
   time_appconnect: 0.000
  time_pretransfer: 0.141
     time_redirect: 0.000
time_starttransfer: 0.280
                   -------
        time_total: 0.280
{% endhighlight %}

Check out the [curl man page](http://curl.haxx.se/docs/manpage.html) for a detailed explanation of each of the used `%{variable}`s.
