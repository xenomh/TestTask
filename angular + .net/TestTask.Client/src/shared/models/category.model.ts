export interface Category {
  categoryId: number;
  categoryName: string;
  parentCategoryId: number | null;
  subCategories: Category[];
}
