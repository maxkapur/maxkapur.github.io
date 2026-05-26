+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'

[params]
id = "{{ sha256 now.UnixNano }}"
+++
