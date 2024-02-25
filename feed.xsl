<!--
  Based on
  https://gist.github.com/andrewstiefel/57a0a400aa2deb6c9fe18c6da4e16e0f
-->
<xsl:stylesheet
 version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:atom="http://www.w3.org/2005/Atom"
 exclude-result-prefixes="atom"
>
 <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
 <xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <title><xsl:value-of select="atom:feed/atom:title" /> | RSS</title>
    <link rel="stylesheet" href="/assets/main.css" />
    <style type="text/css">
     body.feed {
     display: flex;
     gap: 40px;
     padding: 40px 0;
     }
    </style>

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

   <body class="feed">
    <header>
     <div class="wrapper">
      <xsl:apply-templates select="atom:feed" />
     </div>
    </header>
    <main>
     <div class="wrapper">
      <ul>
       <xsl:apply-templates select="atom:feed/atom:entry" />
      </ul>
     </div>
    </main>
   </body>
  </html>
 </xsl:template>

 <xsl:template match="atom:feed">
  <h1>Web feed preview</h1>

    <p>This is a web feed, also known as an RSS feed, for the <a>
    <xsl:attribute name="href">
     <xsl:value-of select="atom:link[@rel='alternate']/@href" />
    </xsl:attribute>
    <xsl:value-of select="atom:title" />
   </a> blog. You can subscribe by copying the URL from the
  address bar into your newsreader app.</p><p>Visit <a href="https://aboutfeeds.com/">About
    Feeds</a> to learn more about newsreaders.</p>
 </xsl:template>

 <xsl:template match="atom:entry">
  <li>
   <a target="_blank">
    <xsl:attribute name="href">
     <xsl:value-of select="atom:id" />
    </xsl:attribute>
    <xsl:value-of select="atom:title" />
   </a>
   <span class="post-meta"> (<xsl:value-of select="atom:updated-readable" />)</span>
   <!-- 
        To incorporate summaries or excerpts (see feed.xml):
	      <xsl:value-of select="atom:summary"  disable-output-escaping="no" />
      -->
  </li>
 </xsl:template>
</xsl:stylesheet>