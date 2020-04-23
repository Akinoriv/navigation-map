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
    <a>  {{trilatiratiom2d()}} </a>
  </div>
  <div id="coords">(координаты покажутся здесь)</div>
   <canvas id="myCanvas"> </canvas>
  
</div> 
</template>

<script>


export default {
  data() {

    return {
      x : {
        a: 0,
        b: 160,
        c: 110
     },
     y : {
        a: 0,
        b: 0,
        c: 60
      },
      z : {
        a: 265,
        b: 0,
        c: 60
      },
      q:[],
      w:[],
      ctx: null,  
      
    }
},
  
  methods: {
   
    updateCanva: function() {
        var canvas = document.getElementById("myCanvas");
        canvas.height = 480;
        canvas.width = 640;
        var ctx = canvas.getContext("2d");        
        var img = new Image();

        img.src = "https://github.com/Akinoriv/vkr/blob/master/src/assets/room.png?raw=true";
        img.onload = function() {
            var pattern = ctx.createPattern(img, "no-repeat");
            ctx.fillStyle = pattern;
            ctx.fillRect(0, 0, 650, 400);
            ctx.stroke(); 
        } 
        //ctx.moveTo(0, 0);
        ctx.rect(this.w, this.q, 5, 5);
        //ctx.stroke(); 
    },
      // var canvas = document.getElementById("example");
      // canvas.height = 480;
      // canvas.width  = 640;

      // var ctx = canvas.getContext('2d');
   
      // //var img = new Image(); 
      // //var img = document.getElementById("123");
      // var img = new Image(); 
      // img.src = "/room.png";
      // img.onload = function() {    
      //   ctx.drawImage(img, this.x, this.y, 250, 260);
      // }
      // this.ctx.beginPath();
      // this.ctx.moveTo(0,0);
      // this.ctx.lineTo(15,0);
      // this.ctx.lineTo(0,15);
      // this.ctx.fill()},
    //   // ctx.beginPath();
		// 	// ctx.moveTo(10, 15);
		// 	// ctx.bezierCurveTo(75, 55, 175, 20, 250, 15);
		// 	// ctx.moveTo(10, 15);
		// 	// ctx.quadraticCurveTo(100, 100, 250, 15);
    //   // ctx.stroke(); 
    // },

    // updateCanva: function() {
    //   var canvas = document.getElementById("example");
    //   canvas.height = 160;
    //   canvas.width  = 256;
    //   this.ctx = canvas.getContext('2d');
    //   this.ctx.strokeRect(0, 0, 256, 160);

    //   this.ctx.beginPath();
    //   this.ctx.moveTo(0,0);
    //   this.ctx.lineTo(15,0);
    //   this.ctx.lineTo(0,15);
    //   this.ctx.fill();

    //   this.ctx.moveTo(256,0);
    //   this.ctx.lineTo(256,15);
    //   this.ctx.lineTo(241,0);
    //   this.ctx.fill();
      
    //   this.ctx.moveTo(0,160);
    //   this.ctx.lineTo(0,145);
    //   this.ctx.lineTo(15,160);
    //   this.ctx.fill();
    
		// 	this.ctx.moveTo(0, 0);
		// 	this.ctx.rect(this.w, this.q, 5, 5);
    //   this.ctx.stroke(); 
    
    // },
// Подсчет координат
    trilatiratiom2d: function () {
      let q = []
      let w = []
      var p1 = -2 * this.x.a * w - 2 * this.x.b * q + Math.pow(this.x.a, 2) + Math.pow(this.x.b, 2) - Math.pow(this.x.c, 2)
      var p2 = -2 * this.y.a * w - 2 * this.y.b * q + Math.pow(this.y.a, 2) + Math.pow(this.y.b, 2) - Math.pow(this.y.c, 2)
      var p3 = -2 * this.z.a * w - 2 * this.z.b * q + Math.pow(this.z.a, 2) + Math.pow(this.z.b, 2) - Math.pow(this.z.c, 2)
      this.w = (p1 - p2) / (2 * this.x.b)
      this.q = -(p2 - p3) / (2 * this.z.a)
      return ("координата х = " + this.q + ", координата y = " + this.w)
    },

  },



// Вывод канваса в интерфейс
  mounted: function () {
    this.updateCanva()
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