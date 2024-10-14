---
layout: page
title: Browse
sort_order: 30
permalink: /browse/
---

All posts by date:

{%- if site.posts.size > 0 -%}
<!-- <h2 class="post-list-heading">{{ page.list_title | default: "Posts" }}</h2> -->
<ul class="atom-post-list">
  {%- for post in site.posts -%}
    {%- if post.unlisted -%}
      {% continue %}
    {%- endif -%}
    <li>
      <div class="atom-post-list-entry">
        <a target="_blank" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
        <span class="post-meta">
          {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
          ({{ post.date | date: date_format }})
        </span>
      </div>
    </li>
  {%- endfor -%}
</ul>
{%- endif -%}
