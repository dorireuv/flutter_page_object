enum ProductCategory {
  software('Software'),
  tools('Tools'),
  services('Services'),
  testing('Testing'),
  ui('UI');

  final String displayName;
  const ProductCategory(this.displayName);
}
