+++
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'

[params]
id = 'tag:{{ .Site.Params.author.email }},{{ time.Format "2006-01-02" .Date }},{{ .Type | lower }}:{{ .File.ContentBaseName }}'
+++

{{- /* The default ID is a tag URI; see https://www.taguri.org/ */}}
