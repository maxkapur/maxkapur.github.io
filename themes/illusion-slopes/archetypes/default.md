+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'

[params]
id = "{{ now.UnixNano }}"
+++
