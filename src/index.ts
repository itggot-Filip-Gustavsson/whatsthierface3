import * as AJAX from './AJAX'



AJAX.get("/", response => {
    console.log(response)
})

let data = "omg=13&foo=1000"
AJAX.post("https://reqres.in/api/users", data, response => {

})

// let request = new XMLHttpRequest()

// request.open("GET", "http://localhost:4567/stuff", true)

// request.onreadystatechange = function(){
//     console.log(request.readyState)
//     if(request.readyState == XMLHttpRequest.DONE){
//         console.log(request.responseText)
//     }
// }

// request.send()