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

  <!-- Styling -->
  <link rel="stylesheet" href="/assets/main.css" />
  <meta name="theme-color" media="(prefers-color-scheme: light)" content="#fffff5" />
  <meta name="theme-color" media="(prefers-color-scheme: dark)" content="#546270" />

  <!-- Favicon -->
  <link rel="shortcut icon" href="/assets/favicon/favicon.ico" type="image/vnd.microsoft.icon" />
  <link rel="icon" href="/assets/favicon/favicon.ico" sizes="any" />
  <link rel="icon" href="/assets/favicon/favicon.svg" type="image/svg+xml" />
  <link rel="apple-touch-icon" href="/assets/favicon/favicon_180.png" />
  <link rel="manifest" href="/assets/favicon/site.webmanifest" />

    </head>

    <body>
  <header class="site-header" role="banner">
    <div class="wrapper"><div class="site-title-wrapper">
        <div>
          <a class="site-title" rel="author" href="/">Illusion Slopes</a>
        </div>
      </div><nav class="site-nav">
      <div class="page-links"><div>
          <a class="page-link" href="/about/">About</a>
        </div><div>
          <a class="page-link" href="/projects/">Projects</a>
        </div><div>
          <a class="page-link" href="/browse/">Browse</a>
        </div></div>
    </nav></div>
</header>
<main class="page-content">
        <div class="wrapper">
          <xsl:apply-templates select="atom:feed" />
          <ul class="concise-post-list">
            <xsl:apply-templates select="atom:feed/atom:entry" />
          </ul>
        </div>
      </main>
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

      </div>
    </li>
  </xsl:template>
</xsl:stylesheet>
