/**
 * evoSearch
 *
 * Indexing and Search Plugin
 *
 * @author      webber (web-ber12@yandex.ru)
 * @category    plugin
 * @version     0.1
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @events OnDocFormSave
 * @internal    @properties &offset=First line of reindexing;text;0 &rowsperonce=Rows per session to index;text;1 &reindex=Re-index all;text;0 &excludeTmpls=Exclude templates;text; &excludeIDs=Exclude resource IDs;text; &TvNames=TV names to search;textarea; &unpublished=Index unpublished;text;0 &deleted=Index deleted;text;0 &dicts=Use dictionaries;text;rus,eng &prepare=Prepare;text;
 * @internal    @installset base, sample
 * @internal    @modx_category Search
 * @internal    @disabled 1
 */
 
/**
 * before the first launch of the snippet on the front-end of the site, it is necessary to start indexing (save any resource in the admin panel)
 *
 * indexing is started by saving any resource (by calling the onDocFormSave event)
 *
 * when starting indexing for the first time or when you need to reindex, you must set the "Reindex all" parameter = 1, the initial lines and the number of lines per session are set depending on
 * your hosting capabilities (for example 0 and 10,000 respectively - will index rows from 0 in the amount of 10,000 pieces in the database
 * you need to open and resave any document to raise the onDocFormSave event
 *
 * for subsequent work, set "Re-index all" = 0, "Rows per session to index" = 1 
 * in this case, only the document that is saved is re-indexed
 *
 * indexed pagetitle,longtitle,description,introtext,content and specified explicitly in the TV plugin (by name, separated by commas)
 *
*/

return require MODX_BASE_PATH . "assets/plugins/evoSearch/evoSearch.plugin.php";
