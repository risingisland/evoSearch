
## evoSearch - indexing and searching based on morphology
#### English version
---------


### Package composition:
- **`evoSearch` Plugin** - used to index search results. Fields are indexed `pagetitle`, `longtitle` ,`description`, `introtext`, `content` and indicated `TV-параметры`. Требуемые `TV` are specified in the plugin configuration via the admin panel in the field **TV names to search** comma separated. When used to build a list of possible values `TV` snippet `multiParams` (from the kit `eFilter`) not indexed `id` resources, and their titles.
- **`evoSearch` Snippet** - used to display search results. It can work in two modes: use `DocLister` to display results or return a list of resource `id` (the mode is selected by the `&action='ids'` parameter). In the latter case, a list of resource ids matching the search conditions is generated and returned. This data can be used in any other snippet through the `evoSearchIDs` placeholder, which contains the `id` array from the search results. 

### Required components to work:
* `DocLister`

### Installation
The easiest way to install is to use the `Extras` module in the admin panel.
As a result, the necessary components will be installed: plugin, snippet, chunks.

The plugin requires the `onDocFormSave` event.

Options:
* `&offset=First line of reindexing;text;0`
* `&rowsperonce=Rows per session to index;text;1`
* `&reindex=Re-index all;text;0`
* `&excludeTmpls=Exclude templates;text;`
* `&excludeIDs=Exclude resource IDs;text;`
* `&TvNames=TV names to search;text;`
* `&unpublished=Index unpublished;text;0`
* `&deleted=Index deleted;text;0`
* `&dicts=Use dictionaries;text;rus,eng`

 ## Important
 * Before the first launch of the snippet on the front-end of the site, it is necessary to index it.
 * The necessary fields `content_with_tv` and` content_with_tv_index`, as well as the necessary indices, are created **automatically** upon the first start of indexing.
 
## First launch and reindexing

1. At the first launch or reindexing, set the parameters in the plugin:
* Re-index all = 1
* First line of reindexing = 0 *
* Rows per session to index = 10 000 *
2. open and resave any document - required to trigger the event `onDocFormSave`.
3. Install *Re-index all = 0*, *Rows per session to index = 1* 

\* Set the first line and the number of lines per session depending on the hosting capabilities.
for example, **First line 0** and **lines per session 10 000** will index in the database rows with 0 in the amount of 10,000 pieces.

### Call example
    to display results [!evoSearch? &tpl=`evoSearch`!]
The `evoSearch` chunk is created when the add-on is installed.

### SNIPPET PARAMETERS
The `evoSearch` snippet wraps `DocLister`, so it takes all `DocLister` parameters.
 + **&action = ids** - returns a list of found `ids` that can be substituted into another snippet. By default - it works completely with the output of the results
 + **&noResult** - the pattern of the string that is displayed when there is no search result. Default value:
 ```
 &noResult = "On request <u>[+stat_request+]</u> Nothing found. Soften your search terms")
 ```
 + **&extract** - disable the extractor. Generates the desired part of the text with highlighting from the search results. Placeholder `[+extract+]` in the output chunk of `DocLister` results. Default value:
  ```
 &extract = 1
 ```
 + **&maxlength** - the maximum length of the text portion to be extracted in the search results. Default value:
 ```
 &maxlength = 350
 ```
 + **&show_stat** - showing statistics. Default value:
 ```
 &show_stat = 1
 ```
 + **&statTpl** - statistics display template. Default value:
 ```html
<div class="evoSearch_info">On request <b>[+stat_request+]</b> found total <b>[+stat_total+]</b>. Shown <b>[+stat_display+]</b>, from [+stat_from+] to [+stat_to+]</div>
```
Where
* `[+stat_request+]` - query from string `$_GET['search']`
* `[+stat_total+]` - number of documents found
* `[+stat_display+]` - shown on the current page from `[+stat_from+]` to `[+stat_to+]`

 + **&rel** - search relevance. default 0.01, The higher the number - the more relevant the results and the fewer they are. Default value:
 ```
 &rel = 0.01
 ```
 + **&search_field** - the `$_GET` field for the request. By default, the request is searched for in `$_GET['search']`.
 + **&minlength** - the minimum length of a word that will participate in full-text search. Default value:
  ```
 &minlength = 2
 ```

Highlighting of found words in pagetitle and extract in search results is carried out by the tag <span class = "evoSearch_highlight"> - i.e. it is possible to style it through css files
 
### Additional Information.
* Highlighting found words in `pagetitle` and `extract` in search results is carried out with the tag `<span class =" evoSearch_highlight ">`. It can be styled through css files.
* Because in *MySQL* full-text search without additional settings, only words of at least 4 characters are processed. To improve the search results, an additional search using the `DocLister` filters is used, which improves the results. Especially when they are absent as a result of a regular search.
* Compatible with `DocLister` version ** 1.4.1 and below, 1.4.8 and above **.
* In versions ** 1.4.5, 1.4.6, 1.4.7** there is an incorrect reset of the `$ _GET` line, which is why the processing of empty results is incorrectly triggered.

---------

## Already installed evoSearch via Exras?
### Update your Snippet & Plugin with the following...

**Snippet:**
```
<?php
//site search taking into account word forms (phpMorphy dictionary) 
//works in conjunction with the evoSearch plugin (the plugin indexes, the snippet displays the results)
//to work, you need an installed DocLister snippet
//call example - for displaying results [!evoSearch? &tpl=`evoSearch`!], 
//OPTIONS
//DocLister parameters - since it is a wrapper for DL, then it understands all DocLister parameters - paginate, display, addWhereList (restrictions on displaying templates, id and anything else in search results)
// + &action = `ids` - returns a list of found ids that can be substituted into another snippet. By default - it works completely with the output of the results
// + &output = `1` - works in conjunction with & action = `ids` and specifies whether to display a list of id, or just set their array to the placeholder [+evoSearchIDs+]. By default - 0 - only in placeholder
// + &noResult = `Nothing found` - the template of the string that is displayed if there is no search result (by default "Nothing was found for the query <u>[+stat_request+]</u>. Soften your search terms")
// + &extract = `0` - disable the extractor generates the necessary part of the text with highlighting from the search results (placeholder [+extract+] in the DocLister results output chunk) - by default 1 (do not extract) 
// + &maxlength = `300` - maximum length of the retrieved part of the text in search results (350 by default)
// + &show_stat = `0` - disable display of statistics "found....shown...from...to...". By default - 1 - display is enabled 
// + &statTpl = `` - statistics display template (by default - <div class="evoSearch_info">By request <b>[+stat_request+]</b> found in total <b>[+stat_total+]</b>. Shown <b>[+stat_display+]</b>, from [+stat_from+] to [+stat_to+]</div>), where
//                   [+stat_request+] - query from string $_GET['search']
//                   [+stat_total+] - found total
//                   [+stat_display+] - shown on the current page from [+stat_from+] to [+stat_to+] 
// + &rel = `1` - search relevance, by default 0.01, the higher the number - the more relevant the results and the fewer there are
// + &search_field = `search2` - $_GET field for the request (by default, the request is searched for in $_GET['search'])
// + &minlength = `3` - minimum length of a word that will participate in full-text search (2 by default)
	
return require_once MODX_BASE_PATH . "assets/snippets/evoSearch/evoSearch.snippet.php";
```

**Plugin (GENERAL tab):**
```
/**
 * before the first launch of the snippet on the front-end of the site, it is necessary to start indexing (save any resource in the admin panel)
 *
 * indexing is started by saving any resource (by calling the onDocFormSave event)
 *
 * when starting indexing for the first time or when you need to reindex, you must set the "Reindex all" parameter = 1, the initial lines and the number of lines per session are set depending on
 * the capabilities of your hosting (for example, 0 and 10,000, respectively - will index rows from 0 in the amount of 10,000 pieces in the database
 * you need to open and resave any document to create the onDocFormSave event
 *
 * for subsequent work, set "Re-index all" = 0, "Index lines per session" = 1
 * in this case, only the document that is saved is re-indexed
 *
 * pagetitle, longtitle, description, introtext, content are indexed and specified explicitly in the TV plugin (by name, separated by commas)
 *
*/

return require MODX_BASE_PATH . "assets/plugins/evoSearch/evoSearch.plugin.php";
```

**Plugin (PROPERTIES tab):**
```
{
  "offset": [
    {
      "label": "First line of re-indexing",
      "type": "text",
      "value": "0",
      "default": "0",
      "desc": ""
    }
  ],
  "rowsperonce": [
    {
      "label": "Amount of rows per session to index",
      "type": "text",
      "value": "1",
      "default": "1",
      "desc": ""
    }
  ],
  "reindex": [
    {
      "label": "Re-index the whole site",
      "type": "text",
      "value": "0",
      "default": "0",
      "desc": ""
    }
  ],
  "excludeTmpls": [
    {
      "label": "Exclude the following templates",
      "type": "text",
      "value": "",
      "default": "",
      "desc": ""
    }
  ],
  "excludeIDs": [
    {
      "label": "Exclude these document IDs",
      "type": "text",
      "value": "",
      "default": "",
      "desc": ""
    }
  ],
  "TvNames": [
    {
      "label": "Custom \"TV\" names to search",
      "type": "textarea",
      "value": "",
      "default": "",
      "desc": ""
    }
  ],
  "unpublished": [
    {
      "label": "Show unpublished documents",
      "type": "text",
      "value": "0",
      "default": "0",
      "desc": ""
    }
  ],
  "deleted": [
    {
      "label": "Show deleted documents",
      "type": "text",
      "value": "0",
      "default": "0",
      "desc": ""
    }
  ],
  "dicts": [
    {
      "label": "Use dictionaries",
      "type": "text",
      "value": "eng",
      "default": "rus,eng",
      "desc": ""
    }
  ],
  "prepare": [
    {
      "label": "Prepare (see Doclister docs)",
      "type": "text",
      "value": "",
      "default": "",
      "desc": ""
    }
  ]
}
```