# Exemple des FormData

## Gestion des FormData pour les User 

 - Pour la création du User

``` js

const formData = {

    "pseudo" : "Exemple",
    "email" : "email",
    "password" : "password"
};

// Url de la route : POST localhost:3000/users/create

/* Commentaire Backeux 

Revoir les arguments et les valeur de retour de la fonction create_users. Pas besoin du new_id ? Ne pas récupérer les valeur firstname, lastname ? Avatar ???

*/

```

  - Pour l'update d'un User

``` js 

const formData = {

    "user_id" : 1, // Doit être un integer, url ou body ? 
    "pseudo" : "example", // Obligatoire ? 
    "email" : "email" // Obligatoire ?
    "firstname" : "firstname" // Default ? 
    "lastname" : "lastname" // Default ? 

}

// Url de la route : POST localhost:3000/users/update/:id

/* Commentaire Backeux 

Revoir les arguments, ne pas les rendre obligatoire possible ? 
Interêt req.params ou req.body ? 

*/

 ```

  - Pour le Delete d'un user

```js 

    // Pas besoin de form, on passe l'id du user dans la requête

    // url de la route : delete localhost:3000/users

```


  - Pour récupérer tous les users


```js 

    // Pas besoin de form, appel de la route suffit

    // url de la route : get localhost:3000/users

```

  - Pour le login d'un User

```js

    const formData = {

        "email" : "email",
        "password" : "password"
    }

    // url de la route : POST localhost:3000/users/login
    // Cette route renvera le User avec ses games, ses invites et ses characters sous ce format 

    user = {

        "id" : 1,
        "email" : "email",
        "is_admin" : true,
        "firstname" : "link"
        "lastname" : "ocarina"
        "pseudo" : "OfTime"
        "Games" : [
            {
                "name" : " Fight Ganondorf !",
                "status" : "Branche la Nintendo",
                "description" : "Terminons ce combat pour sauver Zelda... encore !",
                "max_players" : 1 // Why not ? 
            }
        ],
        "Characters" : [
            {
                "firstname" : "Sheik",
                "lastname" : "Impa"
            }
        ],
        "Invite" : [
            {
                "user_id" : 1,
                "game" : 5
            },
            {
                "user_id" : 12,
                "game" : 8
            }
        ]
    }

/* Commentaire Backeux : On à pas pensé à faire une jointure sur l'invite pour récupérer peut-être le nom de la game associé, sa description et le pseudo du User qui à lancé l'invite ???? 

*/

```

 - Question sur l'interêt d'une route pour récupérer le user par son id avec uniquement les informations de la table Users ??? 

## Gestion des Characters

  - Pour récupérer le character avec tout ses éléments

```js

    // Pas besoin de form mais uniquement de l'id du characters, la route renverra le character avec tous les éléments lui étant associé dans un json sous ce format : 

    "Characters" : {

        "firstname" : "Tom",
        "lastname" : "Cruse",
        "race" :"humain",
        "is_alive" : true,
        "class" : "Dernier Samouraï"
        "skills" : [
            {
                "id" : 1,
                "name" : "coup de katana",
                "description" : "pas de besoin d'un dessin"
            }
        ],
        "items" : [
            {
                "id" : 1,
                "name" : "Journal",
                "quantity" : 1,
                "description" : " Pour raconter son histoire..."
            }
        ],
        "characteristic" : [
                {
                    "strength" : 17,
                    "dexterity" : 17,
                    "constitution" : 17,
                    "wisdom" : 17,
                    "charisma" : 17,
                    "intelligence" : 17,
                    "level" : 17,
                    "max_hp" : 17,
                    "current_hp" : 17,
                    "max_mana" : 17,
                    "current_mana" : 17
                }   
            ]
    }

    // Url de la route : GET localhost:3000/characters/:id

```

  - Pour la création de character

Le formulaire passé devrait être sous ce format 

```js 

const FormData = [
    
    "characters" : {
        "firstname" : "Tom",
        "lastname" : "Cruse",
        "race" :"humain",
        "is_alive" : true,
        "class" : "Dernier Samouraï"

        },
        "skills" : [
            {
                "id" : 1,
                "name" : "coup de katana",
                "description" : "pas de besoin d'un dessin"
            }
        ],
        "items" : [
            {
                "id" : 1,
                "name" : "Journal",
                "quantity" : 1,
                "description" : " Pour raconter son histoire..."
            }
        ],
        "characteristic" : [
                {
                    "strength" : 17,
                    "dexterity" : 17,
                    "constitution" : 17,
                    "wisdom" : 17,
                    "charisma" : 17,
                    "intelligence" : 17,
                    "level" : 17,
                    "max_hp" : 17,
                    "current_hp" : 17,
                    "max_mana" : 17,
                    "current_mana" : 17
                }   
            ]

```