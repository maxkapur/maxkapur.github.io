---
---

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  exclude-result-prefixes="atom"
>

<!--
  This XML stylesheet is based on one by Andrew Stiefel:

  https://gist.github.com/andrewstiefel/57a0a400aa2deb6c9fe18c6da4e16e0f
-->

  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
      <title><xsl:value-of select="atom:feed/atom:title" /> | RSS</title>

      {%- include styling.html %}
    </head>

    <body>
      {%- include header.html -%}
      <main class="page-content">
        <div class="wrapper">
          <xsl:apply-templates select="atom:feed" />
          <ul class="concise-post-list">
            <xsl:apply-templates select="atom:feed/atom:entry" />
          </ul>
        </div>
      </main>

      {%- comment -%}
        TODO: Cannot include footer because it uses XML namespaces internally
        that cause the styled XML feed to fail to render.
        {%- include footer.html -%}
      {%- endcomment %}
    </body>

    </html>
  </xsl:template>

  <xsl:template match="atom:feed">
    <article class="post">
      <header class="post-header">
        <h1 class="post-title">Web feed preview</h1>
      </header>
      <div class="post-content">
        <p>This is a web feed, also known as an RSS feed, for the <a>
          <xsl:attribute name="href">
            <xsl:value-of select="atom:link[@rel='alternate']/@href" />
          </xsl:attribute>
          <xsl:value-of select="atom:title" />
        </a> blog. You can subscribe by copying the URL from the
        address bar into your newsreader app.</p>
        <p>Visit <a href="https://aboutfeeds.com/">About
          Feeds</a> to learn more about newsreaders.</p>
      </div>
    </article>
  </xsl:template>

  <xsl:template match="atom:entry">
    <li>
      <div class="concise-post-list-entry">

        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="atom:id" />
          </xsl:attribute>
          <xsl:value-of select="atom:title" />
        </a>
        &#8203; <!-- == &ZeroWidthSpace; -->
        <span class="post-meta">
          <time>
            <xsl:attribute name="datetime">
              <xsl:value-of select="atom:published" />
            </xsl:attribute>
            (<xsl:value-of select="atom:readableDate" />)
          </time>
        </span>

        {%- comment -%}
          Uncomment below to incorporate post excerpts into the styled preview.
          Note that the excerpts are included in the *feed itself* in either
          case, as defined in feed.xml.

        <!--
          <xsl:value-of select="atom:summary" disable-output-escaping="no" />
        -->
        {%- endcomment %}

      </div>
    </li>
  </xsl:template>
</xsl:stylesheet>
