import pandas as pd
import numpy as np
import random
from deap import base
from deap import creator
from deap import tools

total_calories = 2500 * 7
percentage_prot = 0.3
percentage_carb = 0.5
percentage_fat = 0.2

# compute total calories per macro
cal_prot = round(percentage_prot * total_calories)
cal_carb = round(percentage_carb * total_calories)
cal_fat = round(percentage_fat * total_calories)
print(cal_prot, cal_carb, cal_fat)

# fixed info on macro nutriments: calories per gram of protein, carb and fat
prot_cal_p_gram = 4
carb_cal_p_gram = 4
fat_cal_p_gram = 9

#goal grams
gram_prot = cal_prot / prot_cal_p_gram
gram_carb = cal_carb / carb_cal_p_gram
gram_fat = cal_fat / fat_cal_p_gram
print(gram_prot, gram_carb, gram_fat)

products_table = pd.DataFrame.from_records([
    ['Banana 1u', 0, 4, 89, 1, 0, 23],
    ['Mandarin 1u', 0, 4, 40, 1, 0, 10],
    ['Ananas 100g', 0, 7, 50, 1, 0, 13],
    ['Grapes 100g', 0, 7, 76, 1, 0, 17],
    ['Chocolate 1 bar', 0, 4, 230, 3, 13, 25],
    
    ['Hard Cheese 100g', 0, 8, 350, 28, 26, 2],
    ['Soft Cheese 100g', 0, 8, 374, 18, 33, 1],
    ['Pesto 100g', 0, 8, 303, 3, 30, 4],
    ['Hoummous 100g', 0, 8, 306, 7, 25, 11],
    ['Aubergine Paste 100g', 0, 4, 228, 1, 20, 8],
    
    ['Protein Shake', 0, 5, 160, 30, 3, 5],
    ['Veggie Burger 1', 0, 5, 220, 21, 12, 3],
    ['Veggie Burger 2', 0, 12, 165, 16, 9, 2],
    ['Boiled Egg', 0, 8, 155, 13, 11, 1],
    ['Backed Egg', 0, 16, 196, 14, 15, 1],
    
    ['Baguette Bread Half', 0, 3, 274, 10, 0, 52],
    ['Square Bread 1 slice', 0, 3, 97, 3, 1, 17],
    ['Cheese Pizza 1u', 0, 3, 903, 36, 47, 81],
    ['Veggie Pizza 1u', 0, 3, 766, 26, 35, 85],
    
    ['Soy Milk 200ml', 0, 1, 115, 8, 4, 11],
    ['Soy Chocolate Milk 250ml', 0, 3, 160, 7, 6,20],
    
])

products_table.columns = ['Name', 'Min', 'Max', 'Calories', 'Gram_Prot', 'Gram_Fat', 'Gram_Carb']

cal_data = products_table[['Gram_Prot', 'Gram_Fat', 'Gram_Carb']]

prot_data = list(cal_data['Gram_Prot'])
fat_data = list(cal_data['Gram_Fat'])
carb_data = list(cal_data['Gram_Carb'])