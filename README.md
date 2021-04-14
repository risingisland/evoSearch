
## evoSearch - indexing and searching based on morphology
#### English version
---------


### Package composition:
- **`evoSearch` plugin** - used to index search results. Fields are indexed `pagetitle`, `longtitle` ,`description`, `introtext`, `content` and indicated `TV-параметры`. Требуемые `TV` are specified in the plugin configuration via the admin panel in the field **TV names to search** comma separated. When used to build a list of possible values `TV` snippet `multiParams` (from the kit `eFilter`) not indexed `id` resources, and their titles.
- **`evoSearch` snippet** - used to display search results. It can work in two modes: use `DocLister` to display results or return a list of resource `id` (the mode is selected by the `&action='ids'` parameter). In the latter case, a list of resource ids matching the search conditions is generated and returned. This data can be used in any other snippet through the `evoSearchIDs` placeholder, which contains the `id` array from the search results. 

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
Сниппет `evoSearch`является оберткой для `DocLister`, поэтому то он принимает все параметры `DocLister`.
 + **&action = ids** - возвращает список найденных `ids`, которые можно подставить в другой сниппет. По-умолчанию - отрабатывает полностью с выводом результатов
 + **&noResult** - шаблон строки, которая выводится при отсутствии результата поиска. Значение по-умолчанию:
 ```
 &noResult = "По запросу <u>[+stat_request+]</u> ничего не найдено. Смягчите условия поиска")
 ```
 + **&extract** - отключить экстрактор. Формирует нужную часть текста с подсветкой из результатов поиска. Плейсхолдер `[+extract+]` в чанке вывода результатов `DocLister`. Значение по-умолчанию:
  ```
 &extract = 1
 ```
 + **&maxlength** - максимальная длина извлекаемой части текста в результатах поиска. Значение по-умолчанию:
 ```
 &maxlength = 350
 ```
 + **&show_stat** - показ статистики. Значение по-умолчанию:
 ```
 &show_stat = 1
 ```
 + **&statTpl** - шаблон показа статистики. Значение по-умолчанию:
 ```html
<div class="evoSearch_info">По запросу <b>[+stat_request+]</b> найдено всего <b>[+stat_total+]</b>. Показано <b>[+stat_display+]</b>, c [+stat_from+] по [+stat_to+]</div>
```
где
* `[+stat_request+]` - запрос из строки `$_GET['search']`
* `[+stat_total+]` - количество найденных документов
* `[+stat_display+]` - показано на текущей странице с `[+stat_from+]` по `[+stat_to+]`

 + **&rel** - релевантность поиска.по умолчанию 0.01, Чем выше цифра - тем более релевантные результаты и тем их меньше. Значение по-умолчанию:
 ```
 &rel = 0.01
 ```
 + **&search_field** - поле `$_GET` для запроса. По-умолчанию запрос ищется в `$_GET['search']`.
 + **&minlength** - минимальная длина слова, которое будет участвовать в полнотекстовом поиске. Значение по-умолчанию:
  ```
 &minlength = 2
 ```

подсветка найденных слов в pagetitle и extract в результатах поиска осуществляется тегом <span class="evoSearch_highlight"> - т.е. возможна ее стилизация через css-файлы
 
### Additional Information.
* Подсветка найденных слов в `pagetitle` и `extract` в результатах поиска осуществляется тегом `<span class="evoSearch_highlight">`. Возможна ее стилизация через css-файлы.
* Т.к. при полнотекстовом поиске *MySQL* без дополнительных настроект обрабатываются только слова не короче 4 символов. Для улучшения результатов поиска используется дополнительный поиск средствами фильтров `DocLister`, что улучшает результаты. Особенно при их отстутствии в результате обычного поиска.
* Совместим с `DocLister` версии **1.4.1 и ниже, 1.4.8 и выше**.
* В версиях **1.4.5, 1.4.6, 1.4.7** встречается некорректный сброс строки `$_GET`, из-за чего некорректно срабатывает обработка пустых результатов.

---------

## Already installed evoSearch via exras?
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