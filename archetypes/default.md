+++
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'

[params]
id = 'tag:{{ .Site.Params.author.email }},{{ time.Format "2006-01-02" time.Now }},{{ .Type | lower }}:{{ .File.ContentBaseName }}'
+++

{{- /* The default ID is a tag URI; see https://www.taguri.org/. It uses .Now
instead of the post date because hugo.toml says to infer dates from filenames,
but that inference takes place at compile time, not when the frontmatter here is
evaluated. The goal is to be unique, not meaningful, so this isn't a big deal;
Atom consumers have canonical date fields if they need that. */}}
