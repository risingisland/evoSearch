//<?php
/**
 * evoSearch
 * 
 * Displaying search results
 *
 * @author	    webber (web-ber12@yandex.ru)
 * @category 	snippet
 * @version 	0.2
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal	@modx_category Search
 * @internal    @installset base, sample
 */
 
//site search taking into account word forms (phpMorphy dictionary)
//works in conjunction with the evoSearch plugin (plugin indexes, snippet displays results)
//to work, you need an installed DocLister snippet
//call example - for displaying results [!evoSearch? &tpl=`evoSearch`!], 
//OPTIONS
//DocLister parameters - since it is a wrapper for DL, then it understands all DocLister parameters - paginate, display, addWhereList (restrictions on displaying templates, id and anything else in search results)
// + &action = `ids` - returns a list of ids found, which can be substituted into another snippet. By default - it works completely with the output of the results
// + &output = `1` - works in conjunction with & action = `ids` and specifies whether to display a list of id, or just set their array to the placeholder [+ evoSearchIDs +]. By default - 0 - only in placeholder
// + &noResult = `Nothing found` - the template of the string that is displayed if there is no search result (by default" Nothing found for the query <u> [+ stat_request +] </u>. Soften your search terms ")
// + &extract = `0` - disable the extractor generates the necessary part of the text with highlighting from the search results (placeholder [+ extract +] in the DocLister results output chunk) - by default 1 (do not extract)
// + &maxlength = `300` - maximum length of the retrieved part of the text in search results (350 by default)
// + &show_stat = `0` - disable display of statistics "found .... shown ... from ... to ...". By default - 1 - display is enabled
// + &statTpl = `` - statistics display template (by default - <div class = "evoSearch_info"> By request <b> [+ stat_request +] </b> found in total <b> [+ stat_total +] </b>. Shown <b> [+ stat_display +] </b>, c [+ stat_from +] to [+ stat_to +] </div>), where
//              [+stat_request+] - query from string $_GET['search']
//              [+stat_total+] - found total
//              [+stat_display+] - показано на текущей странице с [+stat_from+] по [+stat_to+] 
// + &rel = `1` - search relevance, by default 0.01, the higher the number - the more relevant the results and the fewer there are
// + &search_field = `search2` - the $_GET field for the request (by default, the request is searched for in $_GET ['search'])
// + &minlength = `3` - minimum length of a word that will participate in full-text search (2 by default)
	
return require_once MODX_BASE_PATH . "assets/snippets/evoSearch/evoSearch.snippet.php";

