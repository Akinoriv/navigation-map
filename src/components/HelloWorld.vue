<template>
<div class="container">  
  <h1>Добро пожаловать в локальный навигатор</h1>
  <div> 
    <h2> Введите расстоение до датчика </h2>
    <label for="P1"> Длина №1 </label>
    <input required="true" class=" col-sm-1" type="text"  id="P1" placeholder="P1" v-model="x.c" > 
    <br>
    <label for="P2" > Длина №2 </label>
    <input required="true" class="color col-sm-1" type="text"  id="P2" placeholder="P2" v-model="y.c" > 
    <br>
    <label for="P3"> Длина №3 </label> 
    <input required="true" class=" col-sm-1" type="text"  id="P3" placeholder="P3" v-model="z.c" > 
    
  </div>
  <div>
    <h2>Координаты вашей точки</h2>
    <a>  {{test()}} </a>
  </div>
  <canvas id='example'>Canvas</canvas>
</div> 
</template>

<script>


export default {
  data() {

    return {
      x : {
        a: 0,
        b: 18,
        c: 7.5
     },
     y : {
        a: 0,
        b: 0,
        c: 16
      },
      z : {
        a: 28.5,
        b: 0,
        c: 27
     },
     
      ctx: null,  
      
    }
  
 
},
  
  methods: {
   
    updateCanvas: function() {
      var example = document.getElementById("example");
      this.ctx = example.getContext('2d');
			example.height = 200;
      example.width  = 300;
      rect()
    },
//vironikaaaa
    test: function () {
      let q = []
      let w = []
      var p1 = -2 * this.x.a * w - 2 * this.x.b * q + Math.pow(this.x.a, 2) + Math.pow(this.x.b, 2) - Math.pow(this.x.c, 2)
      var p2 = -2 * this.y.a * w - 2 * this.y.b * q + Math.pow(this.y.a, 2) + Math.pow(this.y.b, 2) - Math.pow(this.y.c, 2)
      var p3 = -2 * this.z.a * w - 2 * this.z.b * q + Math.pow(this.z.a, 2) + Math.pow(this.z.b, 2) - Math.pow(this.z.c, 2)
      w = (p1 - p2) / (2 * this.x.b)
      q = -(p2 - p3) / (2 * this.z.a)
      return ("координата х = " + q + ", координата y = " + w)
      
    } , 
  },
  mounted: function () {
    this.updateCanvas()
    // тут функции при запуске страници которые будут выполняться
  }
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