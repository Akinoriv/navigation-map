<template>
<div class="container">  
    
 <h1>Добро пожаловать в локальный навигатор</h1>
    <div id="coords">(координаты покажутся здесь)</div>
    <img src="imagen.img/Снимок экрана 2020-03-05 в 14.44.59.png" class="img-fluid" style=" width: 700px;height: 400px;" alt="Responsive image">
   
<a> hdsxc vbnjuytrdcbnmkuv {{test()}} </a>
    

  </div>
</template>

<script>
export default {
  data() {

    return {
      x : [{
        a: 0,
        b: 18,
        c: 7.5
     }],
     y : {
        a: 0,
        b: 0,
        c: 16
      },
      z : [{
        a: 28.5,
        b: 0,
        c: 27
     }]
    }
  },
  
  
  methods: {
   // const readline = require('readline'),

    test: function () {
      let q = []
      let w = []
      var p1 = -2 * this.x.a * w - 2 * this.x.b * q + Math.pow(this.x.a, 2) + Math.pow(this.x.b, 2) - Math.pow(this.x.c, 2)
      var p2 = -2 * this.y.a * w - 2 * this.y.b * q + Math.pow(this.y.a, 2) + Math.pow(this.y.b, 2) - Math.pow(this.y.c, 2)
      var p3 = -2 * this.z.a * w - 2 * this.z.b * q + Math.pow(this.z.a, 2) + Math.pow(this.z.b, 2) - Math.pow(this.z.c, 2)
      w = (p1 - p2) / (2 * this.x.b)
      q = -(p2 - p3) / (2 * this.z.a)
      return ("координата х = " + q + ", координата y = " + w)
      
    }  
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>