package commons_lang4cj.text.translate

import std.collection.*

public class EntityArrays {
    public init() {}

    private static let _ISO8859_1_ESCAPE: Array<Array<String>> = [
        ["\u{00A0}", "&nbsp;"],
        ["\u{00A1}", "&iexcl;"],
        ["\u{00A2}", "&cent;"],
        ["\u{00A3}", "&pound;"],
        ["\u{00A4}", "&curren;"],
        ["\u{00A5}", "&yen;"],
        ["\u{00A6}", "&brvbar;"],
        ["\u{00A7}", "&sect;"],
        ["\u{00A8}", "&uml;"],
        ["\u{00A9}", "&copy;"],
        ["\u{00AA}", "&ordf;"],
        ["\u{00AB}", "&laquo;"],
        ["\u{00AC}", "&not;"],
        ["\u{00AD}", "&shy;"],
        ["\u{00AE}", "&reg;"],
        ["\u{00AF}", "&macr;"],
        ["\u{00B0}", "&deg;"],
        ["\u{00B1}", "&plusmn;"],
        ["\u{00B2}", "&sup2;"],
        ["\u{00B3}", "&sup3;"],
        ["\u{00B4}", "&acute;"],
        ["\u{00B5}", "&micro;"],
        ["\u{00B6}", "&para;"],
        ["\u{00B7}", "&middot;"],
        ["\u{00B8}", "&cedil;"],
        ["\u{00B9}", "&sup1;"],
        ["\u{00BA}", "&ordm;"],
        ["\u{00BB}", "&raquo;"],
        ["\u{00BC}", "&frac14;"],
        ["\u{00BD}", "&frac12;"],
        ["\u{00BE}", "&frac34;"],
        ["\u{00BF}", "&iquest;"],
        ["\u{00C0}", "&Agrave;"],
        ["\u{00C1}", "&Aacute;"],
        ["\u{00C2}", "&Acirc;"],
        ["\u{00C3}", "&Atilde;"],
        ["\u{00C4}", "&Auml;"],
        ["\u{00C5}", "&Aring;"],
        ["\u{00C6}", "&AElig;"],
        ["\u{00C7}", "&Ccedil;"],
        ["\u{00C8}", "&Egrave;"],
        ["\u{00C9}", "&Eacute;"],
        ["\u{00CA}", "&Ecirc;"],
        ["\u{00CB}", "&Euml;"],
        ["\u{00CC}", "&Igrave;"],
        ["\u{00CD}", "&Iacute;"],
        ["\u{00CE}", "&Icirc;"],
        ["\u{00CF}", "&Iuml;"],
        ["\u{00D0}", "&ETH;"],
        ["\u{00D1}", "&Ntilde;"],
        ["\u{00D2}", "&Ograve;"],
        ["\u{00D3}", "&Oacute;"],
        ["\u{00D4}", "&Ocirc;"],
        ["\u{00D5}", "&Otilde;"],
        ["\u{00D6}", "&Ouml;"],
        ["\u{00D7}", "&times;"],
        ["\u{00D8}", "&Oslash;"],
        ["\u{00D9}", "&Ugrave;"],
        ["\u{00DA}", "&Uacute;"],
        ["\u{00DB}", "&Ucirc;"],
        ["\u{00DC}", "&Uuml;"],
        ["\u{00DD}", "&Yacute;"],
        ["\u{00DE}", "&THORN;"],
        ["\u{00DF}", "&szlig;"],
        ["\u{00E0}", "&agrave;"],
        ["\u{00E1}", "&aacute;"],
        ["\u{00E2}", "&acirc;"],
        ["\u{00E3}", "&atilde;"],
        ["\u{00E4}", "&auml;"],
        ["\u{00E5}", "&aring;"],
        ["\u{00E6}", "&aelig;"],
        ["\u{00E7}", "&ccedil;"],
        ["\u{00E8}", "&egrave;"],
        ["\u{00E9}", "&eacute;"],
        ["\u{00EA}", "&ecirc;"],
        ["\u{00EB}", "&euml;"],
        ["\u{00EC}", "&igrave;"],
        ["\u{00ED}", "&iacute;"],
        ["\u{00EE}", "&icirc;"],
        ["\u{00EF}", "&iuml;"],
        ["\u{00F0}", "&eth;"],
        ["\u{00F1}", "&ntilde;"],
        ["\u{00F2}", "&ograve;"],
        ["\u{00F3}", "&oacute;"],
        ["\u{00F4}", "&ocirc;"],
        ["\u{00F5}", "&otilde;"],
        ["\u{00F6}", "&ouml;"],
        ["\u{00F7}", "&divide;"],
        ["\u{00F8}", "&oslash;"],
        ["\u{00F9}", "&ugrave;"],
        ["\u{00FA}", "&uacute;"],
        ["\u{00FB}", "&ucirc;"],
        ["\u{00FC}", "&uuml;"],
        ["\u{00FD}", "&yacute;"],
        ["\u{00FE}", "&thorn;"],
        ["\u{00FF}", "&yuml;"]
    ]

    private static let _ISO8859_1_UNESCAPE: Array<Array<String>> = invert(_ISO8859_1_ESCAPE)

    private static let _HTML40_EXTENDED_ESCAPE: Array<Array<String>> = [
        ["\u{0192}", "&fnof;"],
        ["\u{0391}", "&Alpha;"],
        ["\u{0392}", "&Beta;"],
        ["\u{0393}", "&Gamma;"],
        ["\u{0394}", "&Delta;"],
        ["\u{0395}", "&Epsilon;"],
        ["\u{0396}", "&Zeta;"],
        ["\u{0397}", "&Eta;"],
        ["\u{0398}", "&Theta;"],
        ["\u{0399}", "&Iota;"],
        ["\u{039A}", "&Kappa;"],
        ["\u{039B}", "&Lambda;"],
        ["\u{039C}", "&Mu;"],
        ["\u{039D}", "&Nu;"],
        ["\u{039E}", "&Xi;"],
        ["\u{039F}", "&Omicron;"],
        ["\u{03A0}", "&Pi;"],
        ["\u{03A1}", "&Rho;"],
        ["\u{03A3}", "&Sigma;"],
        ["\u{03A4}", "&Tau;"],
        ["\u{03A5}", "&Upsilon;"],
        ["\u{03A6}", "&Phi;"],
        ["\u{03A7}", "&Chi;"],
        ["\u{03A8}", "&Psi;"],
        ["\u{03A9}", "&Omega;"],
        ["\u{03B1}", "&alpha;"],
        ["\u{03B2}", "&beta;"],
        ["\u{03B3}", "&gamma;"],
        ["\u{03B4}", "&delta;"],
        ["\u{03B5}", "&epsilon;"],
        ["\u{03B6}", "&zeta;"],
        ["\u{03B7}", "&eta;"],
        ["\u{03B8}", "&theta;"],
        ["\u{03B9}", "&iota;"],
        ["\u{03BA}", "&kappa;"],
        ["\u{03BB}", "&lambda;"],
        ["\u{03BC}", "&mu;"],
        ["\u{03BD}", "&nu;"],
        ["\u{03BE}", "&xi;"],
        ["\u{03BF}", "&omicron;"],
        ["\u{03C0}", "&pi;"],
        ["\u{03C1}", "&rho;"],
        ["\u{03C2}", "&sigmaf;"],
        ["\u{03C3}", "&sigma;"],
        ["\u{03C4}", "&tau;"],
        ["\u{03C5}", "&upsilon;"],
        ["\u{03C6}", "&phi;"],
        ["\u{03C7}", "&chi;"],
        ["\u{03C8}", "&psi;"],
        ["\u{03C9}", "&omega;"],
        ["\u{03D1}", "&thetasym;"],
        ["\u{03D2}", "&upsih;"],
        ["\u{03D6}", "&piv;"],
        ["\u{2022}", "&bull;"],
        ["\u{2026}", "&hellip;"],
        ["\u{2032}", "&prime;"],
        ["\u{2033}", "&Prime;"],
        ["\u{203E}", "&oline;"],
        ["\u{2044}", "&frasl;"],
        ["\u{2118}", "&weierp;"],
        ["\u{2111}", "&image;"],
        ["\u{211C}", "&real;"],
        ["\u{2122}", "&trade;"],
        ["\u{2135}", "&alefsym;"],
        ["\u{2190}", "&larr;"],
        ["\u{2191}", "&uarr;"],
        ["\u{2192}", "&rarr;"],
        ["\u{2193}", "&darr;"],
        ["\u{2194}", "&harr;"],
        ["\u{21B5}", "&crarr;"],
        ["\u{21D0}", "&lArr;"],
        ["\u{21D1}", "&uArr;"],
        ["\u{21D2}", "&rArr;"],
        ["\u{21D3}", "&dArr;"],
        ["\u{21D4}", "&hArr;"],
        ["\u{2200}", "&forall;"],
        ["\u{2202}", "&part;"],
        ["\u{2203}", "&exist;"],
        ["\u{2205}", "&empty;"],
        ["\u{2207}", "&nabla;"],
        ["\u{2208}", "&isin;"],
        ["\u{2209}", "&notin;"],
        ["\u{220B}", "&ni;"],
        ["\u{220F}", "&prod;"],
        ["\u{2211}", "&sum;"],
        ["\u{2212}", "&minus;"],
        ["\u{2217}", "&lowast;"],
        ["\u{221A}", "&radic;"],
        ["\u{221D}", "&prop;"],
        ["\u{221E}", "&infin;"],
        ["\u{2220}", "&ang;"],
        ["\u{2227}", "&and;"],
        ["\u{2228}", "&or;"],
        ["\u{2229}", "&cap;"],
        ["\u{222A}", "&cup;"],
        ["\u{222B}", "&int;"],
        ["\u{2234}", "&there4;"],
        ["\u{223C}", "&sim;"],
        ["\u{2245}", "&cong;"],
        ["\u{2248}", "&asymp;"],
        ["\u{2260}", "&ne;"],
        ["\u{2261}", "&equiv;"],
        ["\u{2264}", "&le;"],
        ["\u{2265}", "&ge;"],
        ["\u{2282}", "&sub;"],
        ["\u{2283}", "&sup;"],
        ["\u{2284}", "&nsub;"],
        ["\u{2286}", "&sube;"],
        ["\u{2287}", "&supe;"],
        ["\u{2295}", "&oplus;"],
        ["\u{2297}", "&otimes;"],
        ["\u{22A5}", "&perp;"],
        ["\u{22C5}", "&sdot;"],
        ["\u{2308}", "&lceil;"],
        ["\u{2309}", "&rceil;"],
        ["\u{230A}", "&lfloor;"],
        ["\u{230B}", "&rfloor;"],
        ["\u{2329}", "&lang;"],
        ["\u{232A}", "&rang;"],
        ["\u{25CA}", "&loz;"],
        ["\u{2660}", "&spades;"],
        ["\u{2663}", "&clubs;"],
        ["\u{2665}", "&hearts;"],
        ["\u{2666}", "&diams;"],
        ["\u{00A0}", "&nbsp;"],
        ["\u{00A1}", "&iexcl;"],
        ["\u{00A2}", "&cent;"],
        ["\u{00A3}", "&pound;"],
        ["\u{00A4}", "&curren;"],
        ["\u{00A5}", "&yen;"],
        ["\u{00A6}", "&brvbar;"],
        ["\u{00A7}", "&sect;"],
        ["\u{00A8}", "&uml;"],
        ["\u{00A9}", "&copy;"],
        ["\u{00AA}", "&ordf;"],
        ["\u{00AB}", "&laquo;"],
        ["\u{00AC}", "&not;"],
        ["\u{00AD}", "&shy;"],
        ["\u{00AE}", "&reg;"],
        ["\u{00AF}", "&macr;"],
        ["\u{00B0}", "&deg;"],
        ["\u{00B1}", "&plusmn;"],
        ["\u{00B2}", "&sup2;"],
        ["\u{00B3}", "&sup3;"],
        ["\u{00B4}", "&acute;"],
        ["\u{00B5}", "&micro;"],
        ["\u{00B6}", "&para;"],
        ["\u{00B7}", "&middot;"],
        ["\u{00B8}", "&cedil;"],
        ["\u{00B9}", "&sup1;"],
        ["\u{00BA}", "&ordm;"],
        ["\u{00BB}", "&raquo;"],
        ["\u{00BC}", "&frac14;"],
        ["\u{00BD}", "&frac12;"],
        ["\u{00BE}", "&frac34;"],
        ["\u{00BF}", "&iquest;"],
        ["\u{00D7}", "&times;"],
        ["\u{00F7}", "&divide;"],
        ["\u{0152}", "&OElig;"],
        ["\u{0153}", "&oelig;"],
        ["\u{0160}", "&Scaron;"],
        ["\u{0161}", "&scaron;"],
        ["\u{0178}", "&Yuml;"],
        ["\u{02C6}", "&circ;"],
        ["\u{02DC}", "&tilde;"],
        ["\u{2002}", "&ensp;"],
        ["\u{2003}", "&emsp;"],
        ["\u{2009}", "&thinsp;"],
        ["\u{200C}", "&zwnj;"],
        ["\u{200D}", "&zwj;"],
        ["\u{200E}", "&lrm;"],
        ["\u{200F}", "&rlm;"],
        ["\u{2013}", "&ndash;"],
        ["\u{2014}", "&mdash;"],
        ["\u{2018}", "&lsquo;"],
        ["\u{2019}", "&rsquo;"],
        ["\u{201A}", "&sbquo;"],
        ["\u{201C}", "&ldquo;"],
        ["\u{201D}", "&rdquo;"],
        ["\u{201E}", "&bdquo;"],
        ["\u{2020}", "&dagger;"],
        ["\u{2021}", "&Dagger;"],
        ["\u{2030}", "&permil;"],
        ["\u{2039}", "&lsaquo;"],
        ["\u{203A}", "&rsaquo;"],
        ["\u{20AC}", "&euro;"]
    ]

    private static let _HTML40_EXTENDED_UNESCAPE: Array<Array<String>> = invert(_HTML40_EXTENDED_ESCAPE)

    private static let _BASIC_ESCAPE: Array<Array<String>> = [
        ["\"", "&quot;"],
        ["&", "&amp;"],
        ["<", "&lt;"],
        [">", "&gt;"]
    ]

    private static let _BASIC_UNESCAPE: Array<Array<String>> = invert(_BASIC_ESCAPE)

    private static let _APOS_ESCAPE: Array<Array<String>> = [
        ["'", "&apos;"]
    ]

    private static let _APOS_UNESCAPE: Array<Array<String>> = invert(_APOS_ESCAPE)

    private static let _JAVA_CTRL_CHARS_ESCAPE: Array<Array<String>> = [
        ["\b", "\\b"],
        ["\n", "\\n"],
        ["\t", "\\t"],
        ["\f", "\\f"],
        ["\r", "\\r"]
    ]

    private static let _JAVA_CTRL_CHARS_UNESCAPE: Array<Array<String>> = invert(_JAVA_CTRL_CHARS_ESCAPE)

    public static func APOS_ESCAPE(): Array<Array<String>> {
        clonePairs(_APOS_ESCAPE)
    }

    public static func APOS_UNESCAPE(): Array<Array<String>> {
        clonePairs(_APOS_UNESCAPE)
    }

    public static func BASIC_ESCAPE(): Array<Array<String>> {
        clonePairs(_BASIC_ESCAPE)
    }

    public static func BASIC_UNESCAPE(): Array<Array<String>> {
        clonePairs(_BASIC_UNESCAPE)
    }

    public static func HTML40_EXTENDED_ESCAPE(): Array<Array<String>> {
        clonePairs(_HTML40_EXTENDED_ESCAPE)
    }

    public static func HTML40_EXTENDED_UNESCAPE(): Array<Array<String>> {
        clonePairs(_HTML40_EXTENDED_UNESCAPE)
    }

    public static func ISO8859_1_ESCAPE(): Array<Array<String>> {
        clonePairs(_ISO8859_1_ESCAPE)
    }

    public static func ISO8859_1_UNESCAPE(): Array<Array<String>> {
        clonePairs(_ISO8859_1_UNESCAPE)
    }

    public static func JAVA_CTRL_CHARS_ESCAPE(): Array<Array<String>> {
        clonePairs(_JAVA_CTRL_CHARS_ESCAPE)
    }

    public static func JAVA_CTRL_CHARS_UNESCAPE(): Array<Array<String>> {
        clonePairs(_JAVA_CTRL_CHARS_UNESCAPE)
    }

    public static func invert(array: Array<Array<String>>): Array<Array<String>> {
        let out = ArrayList<Array<String>>()
        for (p in array) {
            out.add([p[1], p[0]])
        }
        out.toArray()
    }

    private static func clonePairs(array: Array<Array<String>>): Array<Array<String>> {
        let out = ArrayList<Array<String>>()
        for (p in array) {
            out.add([p[0], p[1]])
        }
        out.toArray()
    }
}
