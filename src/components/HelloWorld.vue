<template>
<div class="container">  
  <h1>Добро пожаловать в локальный навигатор</h1>
  <div> 
    <h2> Введите расстоение до датчика </h2>
    <label for="P1"> Длина №1 </label>
    <input required="true" class="col-sm-1" type="text"  id="P1" placeholder="P1" v-model="x.c" > 
    <br>
    <label for="P2"> Длина №2 </label>
    <input required="true" class="col-sm-1" type="text"  id="P2" placeholder="P2" v-model="y.c" > 
    <br>
    <label for="P3"> Длина №3 </label> 
    <input required="true" class="col-sm-1" type="text"  id="P3" placeholder="P3" v-model="z.c" > 
    
  </div>
  <div>
    <h2>Координаты вашей точки</h2> 
    <a> {{trilatiratiom2d()}} </a>
  </div>
  <div>
    <h3> Введите номера кабинетов для построения маршрута </h3> <p> Доступные значения: g227, g2271, g2273, g226, g2261, g2262, g225, g224, g223, </p>
     <label for="c1"> A </label>
    <input required="true" class="col-sm-1" type="text"  id="c1" placeholder="c1" 
      v-model="cabinets.a"
      v-on:change="updateCanva()"
    > 
    <br>
    <label for="c2"> B </label> 
    <input required="true" class="col-sm-1" type="text"  id="c2" placeholder="c2" 
      v-model="cabinets.b" 
      v-on:change="updateCanva()"
    >
    <h2> Граф </h2>
    <a> </a> 
    <!-- {{graphSave()}} -->
  </div>
  <div id="coords">(координаты покажутся здесь)</div>
  <canvas id="myCanvas"> Карта </canvas>
  
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
        c: 70
      },
      z : {
        a: 265,
        b: 0,
        c: 40
      },
      q:[],
      w:[],
      ctx: null,  
      
      map : {},
      mapCoord : {},
      mapWay : {},
      cabinets : {
        a : 'g2272',
        b : 'g227', 
              }
    }
},
  
  methods: {

// Отображение канваса
    updateCanva: function() {

      this.graphFine()

      var canvas = document.getElementById("myCanvas");
      canvas.height = 474;
      canvas.width = 552;
      var ctx = canvas.getContext("2d");        
      var img = new Image();
      img.src = "https://github.com/Akinoriv/vkr/blob/master/src/assets/mapG2F.png?raw=true";

      img.onload = function() {
        
        var pattern = ctx.createPattern(img, "no-repeat");
        ctx.fillStyle = pattern;
        ctx.fillRect(0, 0, 552, 480);
        ctx.stroke(); // для отображения всего поверх картинки
      } 

      // canvas.addEventListener('mousemove', function (e) {
      //   let z = window.getComputedStyle(canvas).zoom || 1;     
      //   var x = e.pageX/z - e.target.offsetLeft,
      //   y = e.pageY/z - e.target.offsetTop;
      //   ctx.fillRect(0, 0, 640, 480);
      //   ctx.beginPath();
      //   ctx.arc(x,y,2,0,Math.PI*2,true);
      //   ctx.stroke(); 
      // });
      
      // отрисовать заданный маршрут
      // i = this.mapWay.leght - 1;
      for (let a in this.mapWay ) {
        let id = this.mapWay[a].id;
        let x = this.mapCoord[id].x;
        let y = this.mapCoord[id].y;
        ctx.lineTo(x, y);
        //ctx.rect(x, y, 1, 1);
        }

      // отрисовать все точки на канвас 
      // for (let a in this.mapCoord ) {
      //  ctx.rect(this.mapCoord[a].x, this.mapCoord[a].y, 5, 5);
      // }
      
    },

      test: function (){
        return(this.cabinets.b)
      },

// Подсчет координат
    trilatiratiom2d: function () {
      let q = []
      let w = []
      var p1 = -2 * this.x.a * w - 2 * this.x.b * q + Math.pow(this.x.a, 2) + Math.pow(this.x.b, 2) - Math.pow(this.x.c, 2)
      var p2 = -2 * this.y.a * w - 2 * this.y.b * q + Math.pow(this.y.a, 2) + Math.pow(this.y.b, 2) - Math.pow(this.y.c, 2)
      var p3 = -2 * this.z.a * w - 2 * this.z.b * q + Math.pow(this.z.a, 2) + Math.pow(this.z.b, 2) - Math.pow(this.z.c, 2)
      this.w = (p1 - p2) / (2 * this.x.b)
      this.q = -(p2 - p3) / (2 * this.z.a) + 6 
      return ("координата х = " + this.q + ", координата y = " + this.w)
    },

// Создание и сохранение карты save same map
    graphSave: function () {
      
      let createGraph = require('ngraph.graph');
      let graph = createGraph();

      graph.addLink('Flo1', 'g2272', {weight: 10});
      graph.addLink('Flo1', 'Flo2', {weight: 10});
      graph.addLink('Flo2', 'g227', {weight: 10});
      graph.addLink('Flo2', 'g2271', {weight: 10});
      graph.addLink('Flo2', 'Flo3', {weight: 10});
      graph.addLink('Flo3', 'g2262', {weight: 10});
      graph.addLink('Flo3', 'Flo4', {weight: 10});
      graph.addLink('Flo4', 'g226', {weight: 10});
      graph.addLink('Flo4', 'g2261', {weight: 10});
      graph.addLink('Flo4', 'Flo5', {weight: 10});
      graph.addLink('Flo5', 'Flo6', {weight: 10});
      graph.addLink('Flo6', 'g224', {weight: 10});
      graph.addLink('Flo6', 'g225', {weight: 10});
      graph.addLink('Flo5', 'Flo7', {weight: 10});
      graph.addLink('Flo7', 'g223', {weight: 10});
      graph.addLink('Flo7', 'Flo8', {weight: 10});
      
      //graph.addLink('227-1', '227-2', {weight: 10});

      // сохраняю в джисон связь между точками
      this.map = graph
                                               

      // привязываю точки к координатам на кавас
      let coordinates = {
        'Flo1': {
          x: 222,
          y: 87
        },
        'Flo2': {
          x: 188,
          y: 87
        },
        'g2271': {
          x: 188,
          y: 70
        },
        'g2272': {
          x: 222,
          y: 70
        },
        'g227': {
          x: 188,
          y: 100
        },
        'Flo3': {
          x: 152,
          y: 87
        },
        'Flo4': {
          x: 118,
          y: 87
        },
        'g226': {
          x: 118,
          y: 100
        },
        'g2261': {
          x: 118,
          y: 70
        },
        'g2262': {
          x: 152,
          y: 70
        },
        'Flo5': {
          x: 87,
          y: 87
        },
        'Flo6': {
          x: 87,
          y: 66
        },
        'g224': {
          x: 72,
          y: 66
        },
        'g225': {
          x: 87,
          y: 33
        },
        'Flo7': {
          x: 87,
          y: 124
        },
        'g223': {
          x: 72,
          y: 124
        },
      }

      this.mapCoord = coordinates
      
      return graph
    },

// новая фунуция которая будет  потгружать map    
    graphFine: function () {
      var graph = this.graphSave()

      let path = require('ngraph.path');
      let pathFinder = path.aStar( graph, {
        // We tell our pathfinder what should it use as a distance function:
        distance(fromNode, toNode, link) {
          // We don't really care about from/to nodes in this case,
          // as link.data has all needed information:
          return link.data.weight;
        }
      });
      let myPath = pathFinder.find(this.cabinets.b, this.cabinets.a);
      this.mapWay = myPath 
      return this.mapWay
      
     
    }, 


  },


// тут функции при запуске страници которые будут выполняться
  mounted: function () {
    // Вывод канваса в интерфейс
    this.updateCanva()
    this.graphSave()

 
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