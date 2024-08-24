import { Injectable } from '@angular/core';
import { Category } from '../../shared/models/category.model';
import { HttpClient } from '@angular/common/http';
import { map } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CategoryService {
  constructor(private http: HttpClient) { }

  getCategories() {
    let res = this.http.get<Category[]>('https://localhost:7241/api/v1/categories').pipe(
      map(categories => this.buildCategoryTree(categories))
    );

    return res;
  }

  buildCategoryTree(categories: Category[], parentId: number | null = null): Category[] {
    return categories
      .filter(category => category.parentCategoryId === parentId)
      .map(category => ({
        ...category,
        subCategories: this.buildCategoryTree(categories, category.categoryId)
      }));
  }
}
