class WikiJs {
  /// Android returns JSON-encoded strings, iOS may return plain strings.
  /// Use normalizeTitle to clean it.
  static const String titleQuery =
      "document.querySelector('h1')?.innerText ?? ''";

  static const String cleanDom = r"""
    const hide = s => document.querySelectorAll(s).forEach(e => e.remove());
    hide(`
      #header,
      .header-container,
      .minerva-footer,
      .minerva-header,
      .post-content,
      .navbox,
      .sidebar,
      .mf-page-tools,
      .search-box,
      #mw-mf-page-left,
      .hatnote,
      #p-associated-pages,
      .page-actions-menu
    `);
  """;
}
