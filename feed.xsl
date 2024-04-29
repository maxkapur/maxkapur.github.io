<!--
  Based on
  https://gist.github.com/andrewstiefel/57a0a400aa2deb6c9fe18c6da4e16e0f
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom"
  exclude-result-prefixes="atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
      <title><xsl:value-of select="atom:feed/atom:title" /> | RSS</title>
      <link rel="stylesheet" href="/assets/main.css" />

      <!-- Favicon -->
      <link rel="apple-touch-icon" sizes="180x180" href="/assets/images/apple-touch-icon.png" />
      <link rel="icon" type="image/png" sizes="32x32" href="/assets/images/favicon-32x32.png" />
      <link rel="icon" type="image/png" sizes="16x16" href="/assets/images/favicon-16x16.png" />
      <link rel="manifest" href="/assets/images/site.webmanifest" />
      <link rel="mask-icon" href="/assets/images/safari-pinned-tab.svg" color="#008000" />
      <link rel="shortcut icon" href="/assets/images/favicon.ico" />
      <meta name="msapplication-TileColor" content="#ffc40d" />
      <meta name="msapplication-config" content="/assets/images/browserconfig.xml" />
      <meta name="theme-color" content="#ffffff" />
    </head>

    <body><header class="site-header" role="banner">

  <div class="wrapper"><a class="site-title" rel="author" href="/">Illusion Slopes</a><nav class="site-nav">
        <input type="checkbox" id="nav-trigger" class="nav-trigger" />
        <label for="nav-trigger">
          <span class="menu-icon">
            <svg viewBox="0 0 18 15" width="18px" height="15px">
              <path d="M18,1.484c0,0.82-0.665,1.484-1.484,1.484H1.484C0.665,2.969,0,2.304,0,1.484l0,0C0,0.665,0.665,0,1.484,0 h15.032C17.335,0,18,0.665,18,1.484L18,1.484z M18,7.516C18,8.335,17.335,9,16.516,9H1.484C0.665,9,0,8.335,0,7.516l0,0 c0-0.82,0.665-1.484,1.484-1.484h15.032C17.335,6.031,18,6.696,18,7.516L18,7.516z M18,13.516C18,14.335,17.335,15,16.516,15H1.484 C0.665,15,0,14.335,0,13.516l0,0c0-0.82,0.665-1.483,1.484-1.483h15.032C17.335,12.031,18,12.695,18,13.516L18,13.516z"/>
            </svg>
          </span>
        </label>

        <div class="trigger"><a class="page-link" href="/about/">About me</a><a class="page-link" href="/projects/">Projects</a></div>
      </nav></div>
</header>
<main class="page-content">
        <div class="wrapper">
          <xsl:apply-templates select="atom:feed" />
          <ul class="atom-post-list">
            <xsl:apply-templates select="atom:feed/atom:entry" />
          </ul>
        </div>
      </main>
      <!--
        TODO: Cannot include footer because it uses XML namespaces internally
        that cause the styled XML feed to fail to render.<footer class="site-footer h-card">
  <data class="u-url" href="/"></data>

  <div class="wrapper">

    <h2 class="footer-heading">Illusion Slopes</h2>

    <div class="footer-col-wrapper">
      <div class="footer-col footer-col-1">
        <ul class="contact-list">
          <li class="p-name">Max Kapur</li><li><a class="u-email" href="mailto:max@maxkapur.com">max@maxkapur.com</a></li></ul>
      </div>

      <div class="footer-col footer-col-2"><ul class="social-media-list"><li><a href="/feed.xml"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#rss"></use></svg> <span class="rss-link">via RSS</span></a></li><li><a href="https://github.com/maxkapur"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#github"></use></svg> <span class="username">maxkapur</span></a></li><li><a href="https://www.linkedin.com/in/maxkapur"><svg class="svg-icon"><use xlink:href="/assets/minima-social-icons.svg#linkedin"></use></svg> <span class="username">maxkapur</span></a></li></ul>
</div>

      <div class="footer-col footer-col-3">
        <p>I am an operations research analyst at the consulting firm Booz Allen Hamilton. All opinions are my own.</p>
      </div>
    </div>

  </div>

</footer>
-->
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
      <div class="atom-post-list-entry">
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="atom:id" />
          </xsl:attribute>
          <xsl:value-of select="atom:title" />
        </a>
        <span class="post-meta"> (<xsl:value-of select="atom:updated-readable" />)</span>
        <!--
          Uncomment below to incorporate post excerpts into the styled preview.
          Note that the excerpts are included in the *feed itself* in either
          case, as defined in feed.xml.
        -->
        <!-- <xsl:value-of select="atom:summary" disable-output-escaping="no" /> -->
      </div>
    </li>
  </xsl:template>
</xsl:stylesheet>
