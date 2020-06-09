using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace M4PL.Utilities
{
	public static class HtmlGenerator
	{
		public static Stream GenerateHtmlFile(DataSet data, string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
		{
			if (data == null)
			{
				throw new ArgumentNullException("data");
			}

			return GenerateHtmlFile(data.GetXml(), xsltFilePath, xsltArgumentsDictionary);
		}

		public static Stream GenerateHtmlFile(string xmlData, string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
		{
			XmlDocument doc = new XmlDocument();
			doc.LoadXml(xmlData);

			return GenerateHtmlFile(doc, xsltFilePath, xsltArgumentsDictionary);
		}

		public static string CleanInvalidXmlChars(string text)
		{
			string re = @"[^\x09\x0A\x0D\x20-\xD7FF\xE000-\xFFFD\x10000-x10FFFF]";
			return Regex.Replace(text, re, string.Empty);
		}

		public static Stream GenerateHtmlFile(IXPathNavigable xmlDocument, string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
		{
			MemoryStream mstream = new MemoryStream();

			try
			{
				XslCompiledTransform xslTransform = new XslCompiledTransform();
				xslTransform.Load(xsltFilePath);

				XsltArgumentList xsltArgumentList = GetArguments(xsltArgumentsDictionary);

				xslTransform.Transform(xmlDocument, xsltArgumentList, mstream);
				mstream.Seek(0, SeekOrigin.Begin);
				return mstream;
			}
			catch
			{
				mstream.Dispose();
				throw;
			}
		}

		public static Stream GenerateHtmlFile(string xsltFilePath, Dictionary<string, string> xsltArgumentsDictionary)
		{
			XmlDocument xmlDoc = new XmlDocument();
			MemoryStream mstream = new MemoryStream();
			XslCompiledTransform xslTransform = new XslCompiledTransform();

			xslTransform.Load(xsltFilePath);

			XsltArgumentList xsltArgumentList = null;
			if (xsltArgumentsDictionary != null)
			{
				xsltArgumentList = new XsltArgumentList();
				foreach (KeyValuePair<string, string> item in xsltArgumentsDictionary)
				{
					xsltArgumentList.AddParam(item.Key, string.Empty, item.Value);
				}
			}

			xslTransform.Transform(xmlDoc, xsltArgumentList, mstream);
			mstream.Seek(0, SeekOrigin.Begin);
			return mstream;
		}

		public static string GenerateHtmlFile(
			string xmlData,
			string xsltFilePath,
			Dictionary<string, string> xsltArgumentsDictionary,
			string rootNode)
		{
			if (string.IsNullOrEmpty(xmlData))
			{
				throw new ArgumentNullException("xmlData");
			}

			int startPosition = 0;
			int endPosition = xmlData.IndexOf(rootNode);
			string changedXmlFile = xmlData.Remove(startPosition, endPosition - 1);

			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(changedXmlFile);

			using (MemoryStream mstream = new MemoryStream())
			{
				XslCompiledTransform xslTransform = new XslCompiledTransform();
				xslTransform.Load(xsltFilePath);

				XsltArgumentList xsltArgumentList = null;
				if (xsltArgumentsDictionary != null)
				{
					xsltArgumentList = new XsltArgumentList();
					foreach (KeyValuePair<string, string> item in xsltArgumentsDictionary)
					{
						xsltArgumentList.AddParam(item.Key, string.Empty, item.Value);
					}
				}

				xslTransform.Transform(xmlDoc, xsltArgumentList, mstream);
				mstream.Seek(0, SeekOrigin.Begin);

				return (new StreamReader(mstream)).ReadToEnd();
			}
		}

		private static XsltArgumentList GetArguments(Dictionary<string, string> xsltArgumentsDictionary)
		{
			XsltArgumentList xsltArgumentList = null;
			if (xsltArgumentsDictionary != null)
			{
				xsltArgumentList = new XsltArgumentList();
				foreach (KeyValuePair<string, string> item in xsltArgumentsDictionary)
				{
					if (item.Value == null) throw new ArgumentNullException(item.Key);

					xsltArgumentList.AddParam(item.Key, string.Empty, item.Value);
				}
			}

			return xsltArgumentList;
		}
	}
}
