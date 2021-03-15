//
//  Enums.swift
//  bw
//
//  Created by chenjie5 on 2017/4/12.
//  Copyright © 2017年 duo. All rights reserved.
//

import Foundation

enum Rotation: String {
    case random = "random"
    case today = "today"
}

/**
 https://docs.microsoft.com/en-us/previous-versions/bing/search/dd251064(v=msdn.10)?redirectedfrom=MSDN
 */
enum BingMKT: String {
    case ar_xa = "ar-XA" //Arabic – Arabia
    case bg_bg = "bg-BG" //Bulgarian – Bulgaria
    case cs_cz = "cs-CZ" //Czech – Czech Republic
    case da_dk = "da-DK" //Danish – Denmark
    case de_at = "de-AT" //German – Austria
    case de_ch = "de-CH" //German – Switzerland
    case de_de = "de-DE" //German – Germany
    case el_gr = "el-GR" //Greek – Greece
    case en_au = "en-AU" //English – Australia
    case en_ca = "en-CA" //English – Canada
    case en_gb = "en-GB" //English – United Kingdom
    case en_id = "en-ID" //English – Indonesia
    case en_ie = "en-IE" //English – Ireland
    case en_in = "en-IN" //English – India
    case en_my = "en-MY" //English – Malaysia
    case en_nz = "en-NZ" //English – New Zealand
    case en_ph = "en-PH" //English – Philippines
    case en_sg = "en-SG" //English – Singapore
    case en_us = "en-US" //English – United States
    case en_xa = "en-XA" //English – Arabia
    case en_za = "en-ZA" //English – South Africa
    case es_ar = "es-AR" //Spanish – Argentina
    case es_cl = "es-CL" //Spanish – Chile
    case es_es = "es-ES" //Spanish – Spain
    case es_mx = "es-MX" //Spanish – Mexico
    case es_us = "es-US" //Spanish – United States
    case es_xl = "es-XL" //Spanish – Latin America
    case et_ee = "et-EE" //Estonian – Estonia
    case fi_fi = "fi-FI" //Finnish – Finland
    case fr_be = "fr-BE" //French – Belgium
    case fr_ca = "fr-CA" //French – Canada
    case fr_ch = "fr-CH" //French – Switzerland
    case fr_fr = "fr-FR" //French – France
    case he_il = "he-IL" //Hebrew – Israel
    case hr_hr = "hr-HR" //Croatian – Croatia
    case hu_hu = "hu-HU" //Hungarian – Hungary
    case it_it = "it-IT" //Italian – Italy
    case ja_jp = "ja-JP" //Japanese – Japan
    case ko_kr = "ko-KR" //Korean – Korea
    case lt_lt = "lt-LT" //Lithuanian – Lithuania
    case lv_lv = "lv-LV" //Latvian – Latvia
    case nb_no = "nb-NO" //Norwegian – Norway
    case nl_be = "nl-BE" //Dutch – Belgium
    case nl_nl = "nl-NL" //Dutch – Netherlands
    case pl_pl = "pl-PL" //Polish – Poland
    case pt_br = "pt-BR" //Portuguese – Brazil
    case pt_pt = "pt-PT" //Portuguese – Portugal
    case ro_ro = "ro-RO" //Romanian – Romania
    case ru_ru = "ru-RU" //Russian – Russia
    case sk_sk = "sk-SK" //Slovak – Slovak Republic
    case sl_sl = "sl-SL" //Slovenian – Slovenia
    case sv_se = "sv-SE" //Swedish – Sweden
    case th_th = "th-TH" //Thai – Thailand
    case tr_tr = "tr-TR" //Turkish – Turkey
    case uk_ua = "uk-UA" //Ukrainian – Ukraine
    case zh_cn = "zh-CN" //Chinese – China
    case zh_hk = "zh-HK" //Chinese – Hong Kong SAR
    case zh_tw = "zh-TW" //Chinese – Taiwan
    
    static let allValues = [de_de, en_gb, en_us, fr_fr, ja_jp, ko_kr, uk_ua, zh_cn]
    //static let allValues = [ar_xa, bg_bg, cs_cz, da_dk, de_at, de_ch, de_de, el_gr, en_au, en_ca, en_gb, en_id, en_ie, en_in, en_my, en_nz, en_ph, en_sg, en_us, en_xa, en_za, es_ar, es_cl, es_es, es_mx, es_us, es_xl, et_ee, fi_fi, fr_be, fr_ca, fr_ch, fr_fr, he_il, hr_hr, hu_hu, it_it, ja_jp, ko_kr, lt_lt, lv_lv, nb_no, nl_be, nl_nl, pl_pl, pt_br, pt_pt, ro_ro, ru_ru, sk_sk, sl_sl, sv_se, th_th, tr_tr, uk_ua, zh_cn, zh_hk, zh_tw]
}
