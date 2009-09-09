<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:lx="http://lx.aerys.in">

  <xsl:output ommit-xml-declaration="yes"
	      method="text"
	      encoding="utf-8"/>

  <xsl:include href="lx-std.xsl"/>

  <xsl:template match="lx:project">
    <!-- <?php -->
    <xsl:value-of select="concat($LX_LT, '?php', $LX_LF, $LX_LF)"/>

    <xsl:apply-templates select="lx:const"/>

    <!-- load LX -->
    <xsl:text>require_once (LX_ROOT . '/src/php/misc/lx-config.php');</xsl:text>
    <xsl:value-of select="$LX_LF"/>

    <!-- set database configurations -->
    <xsl:apply-templates select="lx:database"/>

    <!-- BEGIN MODULES TEST -->
    <xsl:text>$_LX['map'] = array('filters' => array(), 'modules' => array(), 'controllers' => array());</xsl:text>
    <xsl:value-of select="$LX_LF"/>

    <xsl:apply-templates select="lx:filter"/>
    <!-- set controllers map -->
    <xsl:apply-templates select="lx:controller"/>
    <!-- set modules map -->
    <xsl:apply-templates select="lx:module"/>
    <!-- END MODULES TEST -->

    <xsl:value-of select="concat($LX_LF, '?', $LX_GT)"/>
    <!-- ?> -->
  </xsl:template>

  <xsl:template match="lx:project/lx:filter">
    <xsl:text>$_LX['map']['filters']['</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>'] = '</xsl:text>
    <xsl:call-template name="lx:ucfirst">
      <xsl:with-param name="string" select="@name"/>
    </xsl:call-template>
    <xsl:text>Filter';</xsl:text>
    <xsl:value-of select="$LX_LF"/>
  </xsl:template>

  <xsl:template match="lx:const[@name][@value]">
    <xsl:text>define('</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>', </xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>);</xsl:text>
    <xsl:value-of select="$LX_LF"/>
  </xsl:template>

  <xsl:template match="lx:database">
    <xsl:text>$_LX['DATABASES']['</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>'] = array(</xsl:text>
    <xsl:call-template name="lx:for-each">
      <xsl:with-param name="collection" select="@*"/>
      <xsl:with-param name="delimiter" select="', '"/>
    </xsl:call-template>
    <xsl:value-of select="concat(');', $LX_LF)"/>
  </xsl:template>

  <xsl:template match="lx:database/@*">
    <xsl:value-of select="concat($LX_QUOTE, name(), $LX_QUOTE, ' => ')"/>
    <xsl:value-of select="concat($LX_QUOTE, current(), $LX_QUOTE)"/>
  </xsl:template>

  <xsl:template match="lx:controller">
    <xsl:variable name="module" select="ancestor::lx:module"/>

    <xsl:variable name="class">
      <xsl:choose>
	<xsl:when test="@class">
	  <xsl:value-of select="@class"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="lx:ucfirst">
	    <xsl:with-param name="string" select="@name"/>
	  </xsl:call-template>
	  <xsl:text>Controller</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>$_LX['map']</xsl:text>
    <xsl:if test="$module">
      <xsl:text>['modules']['</xsl:text>
      <xsl:value-of select="ancestor::lx:module/@name"/>
      <xsl:text>']</xsl:text>
    </xsl:if>
    <xsl:text>['controllers']['</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>'] = array('class' => '</xsl:text>
    <xsl:value-of select="$class"/>

    <xsl:if test="@default-action">
      <xsl:text>', 'default-action' => '</xsl:text>
      <xsl:value-of select="@default-action"/>
    </xsl:if>

    <xsl:text>', 'filters' => array(</xsl:text>
    <xsl:call-template name="lx:for-each">
      <xsl:with-param name="collection" select="lx:filter"/>
      <xsl:with-param name="delimiter" select="', '"/>
    </xsl:call-template>
    <xsl:text>));</xsl:text>

    <xsl:value-of select="$LX_LF"/>

    <xsl:apply-templates select="lx:alias"/>
  </xsl:template>

  <xsl:template match="lx:filter">
    <xsl:variable name="class">
      <xsl:choose>
	<xsl:when test="@class">
	  <xsl:value-of select="@class"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="lx:ucfirst">
	    <xsl:with-param name="string" select="@name"/>
	  </xsl:call-template>
	  <xsl:text>Filter</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="concat($LX_QUOTE, @name, $LX_QUOTE)"/>
    <xsl:text> => </xsl:text>
    <xsl:value-of select="concat($LX_QUOTE, $class, $LX_QUOTE)"/>
  </xsl:template>

  <xsl:template match="lx:module">
    <xsl:text>$_LX['map']['modules']['</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>'] = array('controllers' => array(), 'filters' => array(</xsl:text>
    <xsl:call-template name="lx:for-each">
      <xsl:with-param name="collection" select="lx:filter"/>
      <xsl:with-param name="delimiter" select="', '"/>
    </xsl:call-template>
    <xsl:text>));</xsl:text>
    <xsl:value-of select="$LX_LF"/>
    <xsl:apply-templates select="lx:controller"/>
    <xsl:apply-templates select="@default-controller"/>
  </xsl:template>

  <xsl:template match="lx:module/@default-controller">
    <xsl:text>$_LX['map']['modules']['</xsl:text>
    <xsl:value-of select="../@name"/>
    <xsl:text>']['controllers'][LX_DEFAULT_CONTROLLER] = $_LX['map']['modules']['</xsl:text>
    <xsl:value-of select="../@name"/>
    <xsl:text>']['controllers']['</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>'];</xsl:text>
    <xsl:value-of select="$LX_LF"/>
  </xsl:template>

  <xsl:template match="lx:alias">
    <xsl:variable name="module" select="ancestor::lx:module"/>
    <xsl:variable name="controller" select="ancestor::lx:controller"/>
    <xsl:variable name="base">
      <xsl:text>$_LX['map']['</xsl:text>

      <xsl:if test="$module">
	<xsl:text>modules']['</xsl:text>
	<xsl:value-of select="$module/@name"/>
	<xsl:text>']['</xsl:text>
      </xsl:if>

      <xsl:text>controllers']['</xsl:text>
    </xsl:variable>

    <xsl:value-of select="$base"/>
    <xsl:value-of select="@name"/>
    <xsl:text>'] = </xsl:text>
    <xsl:value-of select="$base"/>
    <xsl:value-of select="$controller/@name"/>
    <xsl:text>'];</xsl:text>

    <xsl:value-of select="$LX_LF"/>
  </xsl:template>

</xsl:stylesheet>