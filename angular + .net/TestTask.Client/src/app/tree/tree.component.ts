import { Component, OnInit } from '@angular/core';
import { Category } from '../../shared/models/category.model';
import { FlatTreeControl } from '@angular/cdk/tree';
import { MatTreeFlatDataSource, MatTreeFlattener } from '@angular/material/tree';
import { CategoryService } from '../../core/services/category.service';

interface CategoryNode {
  expandable: boolean;
  name: string;
  level: number;
  categoryId: number;
  parentCategoryId: number | null;
  subCategories: Category[];
}

@Component({
  selector: 'app-tree',
  templateUrl: './tree.component.html',
  styleUrls: ['./tree.component.css']  // corrected to styleUrls
})
export class TreeComponent implements OnInit {
  private transformer = (node: Category, level: number): CategoryNode => {
    return {
      expandable: node.subCategories.length > 0,
      name: node.categoryName,
      level: level,
      categoryId: node.categoryId,
      parentCategoryId: node.parentCategoryId,
      subCategories: node.subCategories
    };
  }

  treeControl = new FlatTreeControl<CategoryNode>(
    node => node.level, node => node.expandable);

  treeFlattener = new MatTreeFlattener(
    this.transformer, node => node.level, node => node.expandable, node => node.subCategories);

  dataSource = new MatTreeFlatDataSource(this.treeControl, this.treeFlattener);

  constructor(private categoryService: CategoryService) {}

  ngOnInit() {
    this.categoryService.getCategories().subscribe(data => {
      console.log(data);
      this.dataSource.data = data;
    });
  }

  hasChild = (_: number, node: CategoryNode) => node.expandable;
}