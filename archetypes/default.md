+++
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'

[params]
id = 'tag:{{ .Site.Params.author.email }},{{ time.Format "2006-01-02" "2026-05-27" }}:{{ .Type | lower }}/{{ urls.PathEscape .File.ContentBaseName }}'
+++

{{- /* The default ID is a tag URI and the hardcoded date is intentional:

  - https://www.taguri.org/
  - https://validator.w3.org/feed/docs/error/InvalidTAG.html

*/}}
