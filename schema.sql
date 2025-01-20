/* In this SQL file, write (and comment!) the schema of your database,
including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it */

------ TABLES

--Represent ingredients | ex. 1,avocado,0,0; 2,egg,0,1
DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
    "id" INTEGER,
    "name",
    "in_fridge" INTEGER DEFAULT 0,
    "animal_derived" INTEGER, -- vegan check
    PRIMARY KEY("id")
);

--Represent a list of recipes with a type | ex. 1,chocolate muffins,sweet
DROP TABLE IF EXISTS recipes_list;
CREATE TABLE recipes_list (
    "id" INTEGER,
    "name" NOT NULL,
    "savoury_or_sweet",
    "link",
    PRIMARY KEY("id")
);

--Represent a list of ingredients needed for a recipe | ex. 1,1,2,3
DROP TABLE IF EXISTS recipes_ingredients;
CREATE TABLE recipes_ingredients (
    "id" INTEGER,
    "recipe_id",
    "ingredient_id",
    "amount",
    FOREIGN KEY("recipe_id") REFERENCES "recipes_list"("id")
    PRIMARY KEY("id")
);

------ VIEWS

--Represent all vegan recipes
DROP VIEW IF EXISTS vegan;
CREATE VIEW vegan AS
SELECT DISTINCT "recipe_id", "recipes_list"."name" FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipe_id" = "recipes_list"."id"
JOIN "ingredients" ON "ingredients"."id" = "recipes_ingredients"."ingredient_id"
WHERE "animal_derived" = '0';

--Represent all savoury vegan recipes
DROP VIEW IF EXISTS vegan_savoury;
CREATE VIEW vegan_savoury AS
SELECT DISTINCT "recipe_id", "recipes_list"."name" FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipe_id" = "recipes_list"."id"
JOIN "ingredients" ON "ingredients"."id" = "recipes_ingredients"."ingredient_id"
WHERE "animal_derived" = '0'
AND "savoury_or_sweet" = '1';

--Represent all sweeet vegan recipes
DROP VIEW IF EXISTS vegan_sweet;
CREATE VIEW vegan_sweet AS
SELECT DISTINCT "recipe_id", "recipes_list"."name" FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipe_id" = "recipes_list"."id"
JOIN "ingredients" ON "ingredients"."id" = "recipes_ingredients"."ingredient_id"
WHERE "animal_derived" = '0'
AND "savoury_or_sweet" = '0';

--Represent all shortest savoury recipes (in terms of the list of ingredients)
DROP VIEW IF EXISTS savoury_fewest_ingredients;
CREATE VIEW "savoury_fewest_ingredients" AS
SELECT "name", COUNT ("ingredient_id") AS "number of ingredients" FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipe_id" = "recipes_list"."id"
WHERE "savoury_or_sweet" = '1'
GROUP BY "name"
ORDER BY COUNT ("ingredient_id");

--Represent all shortest sweet recipes (in terms of the list of ingredients)
DROP VIEW IF EXISTS sweet_fewest_ingredients;
CREATE VIEW "sweet_fewest_ingredients" AS
SELECT "name", COUNT ("ingredient_id") AS "number of ingredients" FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipe_id" = "recipes_list"."id"
WHERE "savoury_or_sweet" = '0'
GROUP BY "name"
ORDER BY COUNT ("ingredient_id");

--Represent a view of recipes that you can make from the ingredients you have
DROP VIEW IF EXISTS recipes_ready_to_make;
CREATE VIEW recipes_ready_to_make AS
SELECT "recipes_list"."id", "recipes_list"."name"
FROM "recipes_list"
JOIN "recipes_ingredients" ON "recipes_list"."id" = "recipes_ingredients"."recipe_id"
JOIN "ingredients" ON "recipes_ingredients"."ingredient_id" = "ingredients"."id"
GROUP BY "recipes_list"."id"
HAVING SUM("in_fridge" = 0) = 0;

--Represent a view of ingredients you need for a recipe
DROP VIEW IF EXISTS list_of_ingredients_for_a_recipe;
CREATE VIEW "list_of_ingredients_for_a_recipe" AS
SELECT "recipes_ingredients"."recipe_id", "recipes_list"."name" AS "recipe_name", "ingredients"."name", "recipes_ingredients"."amount"
FROM "recipes_ingredients"
JOIN "recipes_list" ON "recipes_ingredients"."recipe_id" = "recipes_list"."id"
JOIN "ingredients" ON "recipes_ingredients"."ingredient_id" = "ingredients"."id";

--Represent what ingredients you have in fridge
DROP VIEW IF EXISTS fridge;
CREATE VIEW fridge AS
SELECT "name" AS "in the fridge" FROM "ingredients" WHERE "in_fridge" = '1'
;

--Represent a shopping list of what you need to buy based on your fridge
DROP VIEW IF EXISTS shopping_list;
CREATE VIEW shopping_list AS
SELECT "recipe_id", "name" FROM "ingredients"
JOIN "recipes_ingredients" ON "recipes_ingredients"."ingredient_id" = "ingredients"."id"
WHERE "ingredients"."in_fridge" = 0
;

------- INDEXES

--Create indexes to speed common searches
DROP INDEX IF EXISTS "recipes_ingredients_search";
CREATE INDEX "recipe_ingredients_search" ON "recipes_ingredients"("id","recipe_id","ingredient_id");

DROP INDEX IF EXISTS "recipes_list_search";
CREATE INDEX "recipe_list_search" ON "recipes_list"("id","name");
