
## evoSearch - indexing and searching based on morphology
#### English version

---------

> For help and more information, visit the [Evo English Forum](https://forum.evo.im/d/61-ajaxsearch-vs-evosearch/)

> Thanks to @scenduk, @modxuser and @nick0 for their info and examples.

---------


### Package composition:
- **`evoSearch` Plugin** - used to index search results. Fields are indexed `pagetitle`, `longtitle` ,`description`, `introtext`, `content` and indicated `TV-параметры`. Требуемые `TV` are specified in the plugin configuration via the admin panel in the field **TV names to search** comma separated. When used to build a list of possible values `TV` snippet `multiParams` (from the kit `eFilter`) not indexed `id` resources, and their titles.
- **`evoSearch` Snippet** - used to display search results. It can work in two modes: use `DocLister` to display results or return a list of resource `id` (the mode is selected by the `&action='ids'` parameter). In the latter case, a list of resource ids matching the search conditions is generated and returned. This data can be used in any other snippet through the `evoSearchIDs` placeholder, which contains the `id` array from the search results. 

### Required components to work:
* `DocLister`

---------

## Installation

### Step 1: Install evoSearch from Extras
This creates a plugin for indexing content, a snippet (based on DocLister) for outputting results and a chunk for styling individual results - all called evoSearch

### Step 2: First launch and reindexing
You need to do this at the end of your site build, run it once you've finished work on templates, TVs and content. This part indexes all of the content and content within TVs.

* Edit the plugin 'evoSearch' and go to the configuration tab. Set 'Rows per session' (the second field) to 10000 and set 'Reindex All' (the third field) to 1.

* In 'Exclude resource IDs' (the fifth field) add a comma separated list of page IDs that should be excluded from search results - if you change this later then you need to run the re-indexing process again.

* In 'TV names to search' (the sixth field - textarea) add a comma separated list of custom TVs that contain content that needs to be indexed and searchable - by default evoSearch will only look within standard TVs such as pagetitle and content. Again, if you edit this later then you need to run the re-indexing process again.

* Save.

* Now edit any resource/page and save it, this will run the plugin and index all of the site content.

* Go back and edit the plugin 'evoSearch' and change 'Rows per session' (the second field) back to 1 and 'Reindex All' (the third field) back to 0. This will revert back to just indexing the page you've edited on save, rather than the entire site every time you save a resource.

Repeat this process whenever you add new templates or TVs.

---------


### Search form example:
This is to be placed in your template. In Evo 1.4x-2.x, this can replace the AjaxSearch call, within the EVO startup template.

```
<!-- Add Search Form -->
<form action="[~8~]" method="GET">
	<input type="text" name="search" placeholder="Search for...">
	<button type="submit">Search</button>
</form>
```


### evoSearch template chunk example:
This is the template for your resutls page. Added to this example is a call to a TV (Main-Image) to also be displayed.

```
<!-- Template Chunk -->
[[if? &is=`[+Main-Image+]:!empty` &then=`<div class="thumb"><a href="[+url+]" class="th"><img src="[+Main-Image+]" alt="image for [+pagetitle+]" />
<div class="search_title"><a href="[+url+]">[+pagetitle+]</a></div>
<div class="search_extract">[+extract+]</div>
<hr>
```


### Display resutls example:
This is to be placed in your desired results page. For this example we are replacing the AjaxSearch resutls within page id 8 (referenced in the form call), from the default demo install.
This example also includes some additional features:
* An additional search field to be dislayed at the top of the results page.
* Parameter `&maxlength` to adjust the length of the content output.
* Filters to ignore ontent from templates 27 & 28 as well as documents with ID 6 & 88.
* Include an additional TV (Main-Image).
* Pagination below the results.


```
<!-- Add to resutls page -->
<form action="[~8~]" method="GET">
	<input type="text" name="search" id="search" placeholder="Search for..." value="[+stat_request+]">
	<button type="submit">Search</button>
</form>
<hr>

[!evoSearch?
	&tpl=`evoSearch`
	&display=`10`
	&maxlength=`150`
	
	&filters=`AND(
		content:c.template:notin:27,28;
		content:c.id:notin:6,88;
		)`
	
	&tvPrefix=`` 
	&tvList=`Main-Image` 
	&renderTV=`Main-Image`
	
	&statTpl=`<p>Showing results [+stat_from+] - [+stat_to+] of [+stat_total+] for "[+stat_request+]"</p>`
	&noResult=`<p>Nothing was found for "[+stat_request+]"</p>`
	
	&paginate=`pages`
	&PrevNextAlwaysShow=`1` 
	&pageAdjacents=`2` 
	
	&ownerTPL=`@CODE:[+dl.wrap+]`
	
	&TplWrapPaginate=`@CODE:<nav><ul class="pagination">[+wrap+]</ul></nav>` 
	&TplFirstP=`@CODE:<li class="page-item"><a class="page-link" href="[+link+]" title="First">&laquo;</a></li>` 
	&TplFirstI=`@CODE:<li class="page-item disabled"><span class="page-link" title="First">&laquo;</span></li>` 
	&TplPrevP=`@CODE:<li class="page-item"><a class="page-link" href="[+link+]" title="Previous">&lsaquo;</a></li>` 
	&TplPrevI=`@CODE:<li class="page-item disabled"><span class="page-link" title="Previous">&lsaquo;</span></li>` 
	&TplNextP=`@CODE:<li class="page-item"><a class="page-link" href="[+link+]" title="Next">&rsaquo;</a></li>` 
	&TplNextI=`@CODE:<li class="page-item disabled"><span class="page-link" title="Next">&rsaquo;</span></li>` 
	&TplLastP=`@CODE:<li class="page-item"><a class="page-link" href="[+link+]" title="Last">&raquo;</a></li>` 
	&TplLastI=`@CODE:<li class="page-item disabled"><span class="page-link" title="Last">&raquo;</span></li>` 
	&TplPage=`@CODE:<li class="page-item"><a class="page-link" href="[+link+]" title="[+num+]">[+num+]</a></li>`  
	&TplCurrentPage=`@CODE:<li class="page-item active"><span class="page-link" title="[+num+]">[+num+]</span></li>`  
	&TplDotsPage=`@CODE:<li>...</li>`
!]

[+pages+]

```

---------

#### A few other useful examples that can be used within the tpl chunk:

* To display content from a TV (in this example an image from a TV called Main-Image) in the evoSearch results:

```[+Main-Image:isnot=``:then=`<div class="thumb"><a href="[+url+]" class="th"><img src="[+Main-Image+]" alt="image for [+pagetitle+]" /></a></div>`+]```

  OR
  
```[[if? &is=`[+Main-Image+]:!empty` &then=`<div class="thumb"><a href="[+url+]" class="th"><img src="[+Main-Image+]" alt="image for [+pagetitle+]" /></a></div>`]]```

* How to provide a url that 'redirects' to the parent:

By Template: ```<a href="[[if? &is=`[+template+]:is:27` &then=`[~[+parent+]~]` &else=`[+url+]`]]">[+pagetitle+]</a>```

By a TV: ```<a href="[[if? &is=`[+tv.redirect-to-parent+]:is:yes` &then=`[~[+parent+]~]` &else=`[+url+]`]]">[+pagetitle+]</a>```

---------

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
