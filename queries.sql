-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

---- START and UPDATE RECIPES DATABASE: UPLOAD RECIPES with ingredients
/* In order to update the database, you need to update the update_recipes.csv
with the data you want to cope into the corresponding data tables.
Next, in the terminal type:
    DROP TABLE IF EXISTS "temp";
    .import --csv update_recipes.csv temp
Then the code below:*/

INSERT INTO "ingredients" ("name", "animal_derived")
SELECT DISTINCT "temp"."ingredient_name", "temp"."animal_derived"
FROM "temp"
WHERE NOT EXISTS (
    SELECT * FROM "ingredients" WHERE "ingredients"."name" = "temp"."ingredient_name"
) AND "ingredient_name" != 'ingredient_name';

INSERT INTO "recipes_list" ("name","savoury_or_sweet","link")
SELECT DISTINCT "temp"."recipe_name","temp"."savoury_or_sweet","temp"."link"
FROM "temp"
WHERE NOT EXISTS (
    SELECT * FROM "recipes_list" WHERE "recipes_list"."name" = "temp"."recipe_name"
) AND "link" != 'link';

INSERT INTO "recipes_ingredients" ("recipe_id", "ingredient_id","amount")
SELECT
(SELECT "id" FROM "recipes_list" WHERE "name" = "temp"."recipe_name"),
(SELECT "id" FROM "ingredients" WHERE "name" = "temp"."ingredient_name"),
"amount"
FROM "temp"
WHERE NOT EXISTS (
    SELECT * FROM "recipes_ingredients"
    WHERE "recipes_ingredients"."recipe_id" = (SELECT "id" FROM "recipes_list" WHERE "name" = "temp"."recipe_name")
    AND "recipes_ingredients"."ingredient_id" = (SELECT "id" FROM "ingredients" WHERE "name" = "temp"."ingredient_name")
) AND "amount" != 'amount';


---- UPDATE: INGREDIENTS

--UPDATE your FRIDGE
--ADD a new INGREDIENT (if doesn't exist): ex. avocado
INSERT INTO "ingredients"("name","animal_derived")
SELECT 'avocado','0'
WHERE NOT EXISTS (
    SELECT * FROM "ingredients" WHERE "name" = 'avocado'
);

--ADD an existing ITEM: ex. avocado
UPDATE "ingredients"
SET "in_fridge" = '1'
WHERE "name" = 'banana';
SELECT * FROM "fridge";
--REMOVE an ITEM: ex. avocado
UPDATE "ingredients"
SET "in_fridge" = '0'
WHERE "name" = 'avocado';
SELECT * FROM "fridge";


------ OVERVIEW SEARCH (no input)

------- FRIDGE OVERVIEW

-- find a list of INGREDIENTS you ALREADY HAVE in the fridge
SELECT * FROM "fridge";
-- find RECIPES you can make with what you ALREADY HAVE in your fridge
SELECT * FROM "recipes_ready_to_make";

------ RECIPES GENERAL OVERVIEW
-- find ALL recipes
SELECT "id","name" FROM "recipes_list";
-- find all SAVOURY recipes
SELECT "id","name" FROM "recipes_list" WHERE "savoury_or_sweet" = '1';
-- find all SWEET recipes
SELECT "id","name" FROM "recipes_list" WHERE "savoury_or_sweet" = '0';

-- find 5 SAVOURY recipes with the fewest ingredients
SELECT * FROM "savoury_fewest_ingredients"
LIMIT 5;
-- find 5 SWEET recipes with the fewest ingredients
SELECT * FROM "sweet_fewest_ingredients"
LIMIT 5;

---- VEGAN [more vegan search options to be updated in the future]
-- find ALL VEGAN recipes
SELECT * FROM "vegan";
-- find all VEGAN SAVOURY recipes
SELECT * FROM "vegan_savoury";
-- find all VEGAN SWEET recipes
SELECT * FROM "vegan_sweet";


------SPECIFIC SEARCH (with input)

---- LIST of INGREDIENTS - based on a RECIPE
-- ID search: ex. 2
SELECT "name","amount" FROM "list_of_ingredients_for_a_recipe"
WHERE "recipe_id" = '2';
-- NAME search: ex. 'no bake chocolate cake'
SELECT "name","amount" FROM "list_of_ingredients_for_a_recipe"
WHERE "recipe_name" = 'no bake chocolate cake';

---- LIST of RECIPES - based on an ITEM: ex. avocado
SELECT "recipes_list"."id", "name" FROM "recipes_list"
WHERE "recipes_list"."id" in (
    SELECT "recipe_id" FROM "recipes_ingredients"
    WHERE "ingredient_id" in (SELECT "ingredients"."id" FROM "ingredients" WHERE "name" = 'milk')
    );

---- SHOPPING LIST - based on a RECIPE: ex. 1 - pancakes
--ID search: ex. 1
SELECT "name" AS "to buy" FROM 'shopping_list'
WHERE "recipe_id" = '1';
--NAME search: ex. pancakes
SELECT "name" AS "to buy" FROM 'shopping_list'
WHERE "recipe_id" = (
    SELECT "id" FROM "recipes_list" WHERE "name" = 'Pancakes'
);




































]\;

