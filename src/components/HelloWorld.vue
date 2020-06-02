<template>
<div class="container">  
  <h1>Добро пожаловать в навигатор по корпусу Г - 2 этаж </h1>
  <h3> Расчет расстояния до ближайших датчиков </h3>
  <div align="right" class="col-sm-7"> 
    
    <label for="P1"> Длина №1 </label>
    <input required="true" class="col-sm-1" type="text"  id="P1" placeholder="P1" v-model="lengthForSens[0]" > 
    <br>
    <label for="P2"> Длина №2 </label>
    <input required="true" class="col-sm-1" type="text"  id="P2" placeholder="P2" v-model="lengthForSens[1]" > 
    <br>
    <label for="P3"> Длина №3 </label> 
    <input required="true" class="col-sm-1" type="text"  id="P3" placeholder="P3" v-model="lengthForSens[2]" > 
    
  </div>
  <!-- <div>
    <h2>Координаты вашей точки</h2> 
    <a> {{trilatiratiom2d()}}</a> 
  </div> -->
  <h3> Введите номер кабинета, для постоенния маршрута </h3>
  <div align="right" class="col-sm-9">
   
    <label for="c1" align="right" > Откуда: кликните на карте или впишите  </label>
    <input required="true" align="right"  class="col-sm-2" type="text"  id="c1" placeholder="Кабинет А" 
      v-model="cabinets.a"
      v-on:change="updateCanva()"
    > 
    <br>
    <label for="c2" align="right" > Куда: впишите номер кабинета </label> 
    <input required="true" align="right"  class="col-sm-2" type="text"  id="c2" placeholder="Кабинет Б" 
      v-model="cabinets.b" 
      v-on:change="updateCanva()"
    >
    <!-- <h2> Граф </h2>
    <a>{{graphFine()}}</a> 
    {{graphSave()}} -->
  </div>
  <div>
    <!-- <div id="coords">(координаты мышки)</div> -->
    <canvas id="myCanvas"> Обновите браузер </canvas>
  </div>
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
      lengthForSens: [],

      q: [],
      w: [],
      ctx: null,  
      
      map : {},
      mapCoord : {},
      sensCoord : {},
      mapWay : {},
      cabinets : {
        a : 'Г-227',
        b : 'Г-223', 
              },
      mathFun : {
        x: [],
        y: []
      },
      testFun : {
        x: [],
        y: []
      }
    }

},
  
  methods: {

  // Отображение канваса
    updateCanva: function() {

      var that = this;
      
      that.graphFine()

      var canvas = document.getElementById("myCanvas");
      var ctx = canvas.getContext("2d");  
      canvas.height = 474;
      canvas.width = 552;     
      var img = new Image();
      img.src = "https://github.com/Akinoriv/vkr/blob/master/src/assets/mapG2F.png?raw=true";
      // отображение картинки карты
      img.onload = function() {
        var pattern = ctx.createPattern(img, "no-repeat");
        ctx.fillStyle = pattern;
        ctx.fillRect(0, 0, 552, 474);
        ctx.stroke(); // для отображения всего поверх картинки
      } 
 
 
      // работает после нажатия на канвас
      canvas.addEventListener('click', function (e) {
        var q = e.pageX - e.target.offsetLeft;
        var w = e.pageY - e.target.offsetTop;
        ctx.fillRect(0, 0, 552, 474);
        ctx.beginPath();

        // ctx.rect(q, w, 5, 5);
        //  // отрисовать все точки на канвас 
        // for (let a in that.mapCoord ) {
        //   ctx.rect(that.mapCoord[a].x, that.mapCoord[a].y, 4, 4);
        // }

        var idMinCab = '';
        var minD = 10000;

        // ищет ближайшую точку от клика мышки по всему графу
        for (let a in that.mapCoord ) {
          let x = that.mapCoord[a].x;
          let y = that.mapCoord[a].y;     
          var XYmin =  Math.sqrt((q - x)*(q - x) + (w - y)*(w - y));
          // сохраняет ближайшее значение
          if (XYmin <= minD){
            minD = XYmin;
            idMinCab = a;
          }

        }
       

        // перезапись маршрута
        that.cabinets.a = idMinCab;
        that.graphFine();
        that.mathFun.x = that.mapCoord[idMinCab].x;
        that.mathFun.y = that.mapCoord[idMinCab].y;

        // авто отрисовка датчиков
        for (let a in that.mapCoord[idMinCab].sensors) {
          let id = that.mapCoord[idMinCab].sensors[a];
          that.testFun = id;
          let x = that.sensCoord[id].x;
          let y = that.sensCoord[id].y; 
          ctx.rect(x, y, 2, 2);    
          that.lengthForSens[a] =  Math.sqrt((q - x)*(q - x) + (w - y)*(w - y));
        }

        // посторение линий от клика мышки до ближайшего графа
        ctx.moveTo(q, w);
        ctx.lineTo(that.mathFun.x, that.mathFun.y);
        ctx.lineWidth = 5;
        ctx.lineCap = 'round';
        var gradient = ctx.createLinearGradient(0, 0, 460, 460)
        gradient.addColorStop(0.00, 'indigo')
        gradient.addColorStop(0.14, 'violet')
        gradient.addColorStop(0.28, 'blue')
        gradient.addColorStop(0.42, 'violet')
        gradient.addColorStop(0.56, 'blue')
        gradient.addColorStop(0.70, 'indigo')
        gradient.addColorStop(0.84, 'violet')
        ctx.strokeStyle = gradient; 

       
        // построение маршрута 
        for (let a in that.mapWay ) {
          let id = that.mapWay[a].id;
          let x = that.mapCoord[id].x;
          let y = that.mapCoord[id].y;
          ctx.lineTo(x, y);
        }
        // отрисовка
        ctx.stroke(); 
      });
      
    },

      test: function (){
        return(this.testFun)
      },

    // Подсчет координат
    trilatiratiom2d: function () {
      let q = []
      let w = []
      var p1 = -2 * this.x.a * w - 2 * this.x.b * q + Math.pow(this.x.a, 2) 
               + Math.pow(this.x.b, 2) - Math.pow(this.x.c, 2);
      var p2 = -2 * this.y.a * w - 2 * this.y.b * q + Math.pow(this.y.a, 2)
               + Math.pow(this.y.b, 2) - Math.pow(this.y.c, 2);
      var p3 = -2 * this.z.a * w - 2 * this.z.b * q + Math.pow(this.z.a, 2)
               + Math.pow(this.z.b, 2) - Math.pow(this.z.c, 2);
      this.w = (p1 - p2) / (2 * this.x.b)
      this.q = -(p2 - p3) / (2 * this.z.a) + 6 
      return ("координата х = " + this.q + ", координата y = " + this.w)
    },

    // Создание и сохранение карты save same map
    graphSave: function () {
      
      let createGraph = require('ngraph.graph');
      let graph = createGraph();
// связь между графами
      graph.addLink('Flo1', 'Г-227-2f', {weight: 10});
      graph.addLink('Г-227-2f', 'Г-227-2', {weight: 10});

      graph.addLink('Flo1', 'Flo2', {weight: 10});
      graph.addLink('Flo2', 'Г-227f', {weight: 10});
      graph.addLink('Г-227f', 'Г-227', {weight: 10});
      graph.addLink('Flo2', 'Г-227-1f', {weight: 10});
      graph.addLink('Г-227-1f', 'Г-227-1', {weight: 10});

      graph.addLink('Flo2', 'Flo3', {weight: 10});
      graph.addLink('Flo3', 'Г-226-2f', {weight: 10});
      graph.addLink('Г-226-2f', 'Г-226-2', {weight: 10});

      graph.addLink('Flo3', 'Flo4', {weight: 10});
      graph.addLink('Flo4', 'Г-226-1f', {weight: 10});
      graph.addLink('Г-226-1f', 'Г-226-1', {weight: 10});
      graph.addLink('Flo4', 'Г-226f', {weight: 10});
      graph.addLink('Г-226f', 'Г-226', {weight: 10});

      graph.addLink('Flo4', 'Flo5', {weight: 10});

      graph.addLink('Flo5', 'Flo6', {weight: 10});
      graph.addLink('Flo6', 'Г-224f', {weight: 10});
      graph.addLink('Г-224f', 'Г-224', {weight: 10});
      graph.addLink('Flo6', 'Г-225f', {weight: 10});
      graph.addLink('Г-225f', 'Г-225', {weight: 10});
      
      graph.addLink('Flo5', 'Flo7', {weight: 10});
      graph.addLink('Flo7', 'stairs1f', {weight: 10});
      graph.addLink('Flo7', 'Г-223f', {weight: 10});
      graph.addLink('Г-223f', 'Г-223', {weight: 10});

      graph.addLink('stairs1', 'stairs1f', {weight: 10});

      graph.addLink('Flo7', 'Flo8', {weight: 10});
      graph.addLink('Flo8', 'stairs1f', {weight: 10});
      graph.addLink('Flo8', 'Г-222f', {weight: 10});
      graph.addLink('Г-222f', 'Г-222', {weight: 10});

      graph.addLink('Flo8', 'Flo9', {weight: 10});
      graph.addLink('Flo9', 'Г-221f', {weight: 10});
      graph.addLink('Г-221f', 'Г-221', {weight: 10});

      graph.addLink('Flo9', 'Flo10', {weight: 10});
      graph.addLink('Flo10', 'Г-220f', {weight: 10});
      graph.addLink('Г-220f', 'Г-220', {weight: 10});

      graph.addLink('Flo10', 'Flo11', {weight: 10});
      graph.addLink('Flo11', 'Г-219f', {weight: 10});
      graph.addLink('Г-219f', 'Г-219', {weight: 10});

      graph.addLink('Flo11', 'Flo12', {weight: 10});
      graph.addLink('Flo12', 'Г-218f', {weight: 10});
      graph.addLink('Г-218f', 'Г-218', {weight: 10});

      graph.addLink('Flo12', 'Flo13', {weight: 10});
      graph.addLink('Flo13', 'Г-217f', {weight: 10});
      graph.addLink('Г-217f', 'Г-217', {weight: 10});

      graph.addLink('Flo13', 'Flo14', {weight: 10});
      graph.addLink('Flo14', 'Г-215f', {weight: 10});
      graph.addLink('Г-215f', 'Г-215', {weight: 10});
      graph.addLink('Г-215f', 'Г-216f', {weight: 10});
      graph.addLink('Г-216f', 'Г-216', {weight: 10});
      graph.addLink('Г-215f', 'Г-214f', {weight: 10});
      graph.addLink('Г-214f', 'Г-214', {weight: 10});
      graph.addLink('Г-216f', 'Г-214f', {weight: 12});
      graph.addLink('Г-215', 'Г-214f', {weight: 10});
      graph.addLink('Г-215', 'Г-216f', {weight: 10});
      
      graph.addLink('Flo14', 'Flo15', {weight: 10});
      graph.addLink('Flo15', 'Г-213f', {weight: 10});
      graph.addLink('Г-213f', 'Г-213', {weight: 10});
      
      graph.addLink('Flo15', 'Flo16', {weight: 10});
      graph.addLink('Flo16', 'Г-228f', {weight: 10});
      graph.addLink('Г-228f', 'Г-228', {weight: 10});
      graph.addLink('Flo16', 'Г-212f', {weight: 10});
      graph.addLink('Г-212f', 'Г-212p', {weight: 10});
      graph.addLink('Г-212p', 'Г-212-1f', {weight: 10});
      graph.addLink('Г-212-1f', 'Г-212-1', {weight: 10});

      graph.addLink('Flo16', 'Flo17', {weight: 10});
      graph.addLink('Flo17', 'Г-229f', {weight: 10});
      graph.addLink('Г-229f', 'Г-229', {weight: 10});

      graph.addLink('Flo17', 'Flo18', {weight: 10});
      graph.addLink('Flo18', 'Г-230f', {weight: 10});
      graph.addLink('Г-230f', 'Г-230', {weight: 10});

      graph.addLink('Flo18', 'Flo19', {weight: 10});
      graph.addLink('Flo19', 'Г-231f', {weight: 10});
      graph.addLink('Г-231f', 'Г-231', {weight: 10});
      graph.addLink('Flo19', 'Г-212f2', {weight: 10});
      graph.addLink('Г-212f2', 'Г-212', {weight: 10});
      graph.addLink('Г-212', 'Г-212p', {weight: 10});
      graph.addLink('Г-212f2', 'Г-212-1f', {weight: 10});

      graph.addLink('Flo19', 'Flo20', {weight: 10});
      graph.addLink('Flo20', 'Г-211f', {weight: 10});
      graph.addLink('Flo20', 'stairs3', {weight: 10});
      graph.addLink('Г-211f', 'Г-211', {weight: 10});
      graph.addLink('Г-211f', 'Г-211-1f', {weight: 10});
      graph.addLink('Г-211-1f', 'Г-211-1', {weight: 10});

      graph.addLink('Flo20', 'Flo21', {weight: 10});

      graph.addLink('Flo21', 'wc', {weight: 10});
      graph.addLink('Flo21', 'Flo22', {weight: 10});

      graph.addLink('Flo22', 'Flo23', {weight: 10});
      graph.addLink('Flo23', 'Г-210f', {weight: 10});
      graph.addLink('Г-210f', 'Г-210', {weight: 10});
      graph.addLink('Г-210f', 'Г-210-1f', {weight: 10});
      graph.addLink('Г-210-1f', 'Г-210-1', {weight: 10});

      graph.addLink('Flo23', 'Flo24', {weight: 10});
      graph.addLink('Flo24', 'Г-209f', {weight: 10});
      graph.addLink('Г-209f', 'Г-209', {weight: 10});

      graph.addLink('Flo24', 'Flo25', {weight: 10});
      graph.addLink('Flo25', 'Г-208f', {weight: 10});
      graph.addLink('Г-208f', 'Г-208', {weight: 10});
      graph.addLink('Г-208', 'Г-208-1f', {weight: 10});
      graph.addLink('Г-208f', 'Г-208-1f', {weight: 10});
      graph.addLink('Г-208-1f', 'Г-208-1', {weight: 10});

      graph.addLink('Flo25', 'Flo26', {weight: 10});
      graph.addLink('Flo26', 'Г-207f', {weight: 10});
      graph.addLink('Г-207f', 'Г-207', {weight: 10});
      graph.addLink('Г-207', 'Г-207-1f', {weight: 10});
      graph.addLink('Г-207f', 'Г-207-1f', {weight: 10});
      graph.addLink('Г-207-1f', 'Г-207-1', {weight: 10});

      graph.addLink('Flo26', 'Flo27', {weight: 10});
      graph.addLink('Flo27', 'Г-206f', {weight: 10});
      graph.addLink('Г-206f', 'Г-206', {weight: 10});

      graph.addLink('Flo27', 'Flo28', {weight: 10});
      graph.addLink('Flo28', 'Г-205f', {weight: 10});
      graph.addLink('Г-205f', 'Г-205', {weight: 10});
      graph.addLink('Г-205', 'Г-205-1f', {weight: 10});
      graph.addLink('Г-205f', 'Г-205-1f', {weight: 10});
      graph.addLink('Г-205-1f', 'Г-205-1', {weight: 10});

      graph.addLink('Flo28', 'Flo29', {weight: 10});
      graph.addLink('Flo29', 'stairs2f', {weight: 10});
      graph.addLink('Flo29', 'Г-204f', {weight: 10});
      graph.addLink('Г-204f', 'Г-204', {weight: 10});

      graph.addLink('stairs2', 'stairs2f', {weight: 10});


      graph.addLink('Flo29', 'Flo30', {weight: 10});
      graph.addLink('Flo30', 'stairs2f', {weight: 10});
      graph.addLink('Flo30', 'Г-203f', {weight: 10});
      graph.addLink('Г-203f', 'Г-203', {weight: 10});

      graph.addLink('Flo30', 'Г-201f', {weight: 10});
      graph.addLink('Г-201f', 'Г-201', {weight: 10});

      graph.addLink('Г-201', 'Г-201-3f', {weight: 10});
      graph.addLink('Г-201f', 'Г-201-3f', {weight: 10});
      graph.addLink('Г-201-3f', 'Г-201-3', {weight: 10});

      graph.addLink('Г-201', 'Г-201-2f', {weight: 10});
      graph.addLink('Г-201-2f', 'Г-201-2', {weight: 10});

      graph.addLink('Г-201', 'Г-201-4f', {weight: 10});
      graph.addLink('Г-201-4f', 'Г-201-4', {weight: 10});
      graph.addLink('Г-201-4f', 'Г-201-2f', {weight: 10});

      graph.addLink('Г-201-4f', 'Г-201-1f', {weight: 10});
      graph.addLink('Г-201-4', 'Г-201-1f', {weight: 10});
      graph.addLink('Г-201-1f', 'Г-201-1', {weight: 10});

      graph.addLink('Flo30', 'Flo31', {weight: 10});
      graph.addLink('Flo31', 'Г-202f', {weight: 10});
      graph.addLink('Г-202f', 'Г-202', {weight: 10});
      graph.addLink('Г-202', 'Г-202p', {weight: 10});
      graph.addLink('Г-202f', 'Г-202p', {weight: 10});
      graph.addLink('Flo31', 'Г-202-1f', {weight: 10});
      graph.addLink('Г-202-1f', 'Г-202-1', {weight: 10});

      // сохраняю в джисон связь между точками
      this.map = graph                                               

// привязываю точки к координатам на кавас
      let coordinates = {
        'Flo1': {
          x: 220,
          y: 83,
          sensors: [
           'sen_1',
           'sen_2',
           'sen_3'
          ]
        },
        'Г-227-2f': {
          x: 220,
          y: 68,
          sensors: [
            'sen227-2_1',
            'sen227-2_2',
            'sen227-2_3'
            ]
        },
        'Г-227-2': {
          x: 220,
          y: 35,
          sensors: [
            'sen227-2_1',
            'sen227-2_2',
            'sen227-2_3'
            ]
        },

        'Flo2': {
          x: 185,
          y: 83,
          sensors: [
           'sen_2',
           'sen_3',
           'sen_4'
          ]
        },
        'Г-227f': {
          x: 185,
          y: 98,
          sensors: [
           'sen227_1',
           'sen227_2',
           'sen227_3'
          ]
        },
        'Г-227': {
          x: 205,
          y: 115,
          sensors: [
           'sen227_1',
           'sen227_2',
           'sen227_3'
          ]
        },
        
        'Г-227-1f': {
          x: 185,
          y: 68,
          sensors: [
            'sen227-1_1',
            'sen227-1_2',
            'sen227-1_3'
            ]
        },
        'Г-227-1': {
          x: 185,
          y: 35,
          sensors: [
            'sen227-1_1',
            'sen227-1_2',
            'sen227-1_3'
            ]
        },

        'Flo3': {
          x: 150,
          y: 83,
          sensors: [
           'sen_5',
           'sen_3',
           'sen_4'
          ]
        },
        'Г-226-2f': {
          x: 150,
          y: 68,
          sensors: [
            'sen226-2_1',
            'sen226-2_2',
            'sen226-2_3'
            ]
        },
        'Г-226-2': {
          x: 150,
          y: 35,
          sensors: [
            'sen226-2_1',
            'sen226-2_2',
            'sen226-2_3'
            ]
        },

        'Flo4': {
          x: 116,
          y: 83,
          sensors: [
           'sen_5',
           'sen_3',
           'sen_4'
          ]
        },
        'Г-226f': {
          x: 115,
          y: 98,
          sensors: [
            'sen226_1',
            'sen226_2',
            'sen226_3'
            ]
        },
        'Г-226': {
          x: 137,
          y: 115,
          sensors: [
            'sen226_1',
            'sen226_2',
            'sen226_3'
            ]
        },
        'Г-226-1f': {
          x: 116,
          y: 68,
          sensors: [
            'sen226-1_1',
            'sen226-1_2',
            'sen226-1_3'
            ]
        },
        'Г-226-1': {
          x: 115,
          y: 35,
          sensors: [
            'sen226-1_1',
            'sen226-1_2',
            'sen226-1_3'
            ]
        },
        
        'Flo5': {
          x: 85,
          y: 87,
          sensors: [
           'sen_5',
           'sen_6',
           'sen_7'
          ]
        },

        'Flo6': {
          x: 85,
          y: 65,
          sensors: [
           'sen_5',
           'sen_6',
           'sen_7'
          ]
        },
        'Г-224f': {
          x: 71,
          y: 65,
          sensors: [
            'sen224_1',
            'sen224_2',
            'sen224_3'
            ]
        },
        'Г-224': {
          x: 32,
          y: 65,
          sensors: [
            'sen224_1',
            'sen224_2',
            'sen224_3'
            ]
        },
        'Г-225f': {
          x: 85,
          y: 33,
          sensors: [
            'sen225_1',
            'sen225_2',
            'sen225_3'
            ]
        },
         'Г-225': {
          x: 70,
          y: 13,
          sensors: [
            'sen225_1',
            'sen225_2',
            'sen225_3'
            ]
        },

        'Flo7': {
          x: 85,
          y: 120,
          sensors: [
           'sen_8',
           'sen_5',
           'sen_7'
          ]
        },
        'Г-223f': {
          x: 72,
          y: 120,
          sensors: [
            'sen223_1',
            'sen223_2',
            'sen223_3'
            ]
        },
         'Г-223': {
          x: 32,
          y: 118,
          sensors: [
            'sen223_1',
            'sen223_2',
            'sen223_3'
            ]
        },

         'Flo8': {
          x: 85,
          y: 178,
          sensors: [
           'sen_8',
           'sen_9',
           'sen_7'
          ]
        },
// не прописаные  ниже      
         'Г-222f': {
          x: 72,
          y: 178
        },
         'Г-222': {
          x: 34,
          y: 178
        },

         'Flo9': {
          x: 85,
          y: 203
        },
        'Г-221f': {
          x: 72,
          y: 203
        },
        'Г-221': {
          x: 34,
          y: 203
        },

         'Flo10': {
          x: 85,
          y: 235
        },
        'Г-220f': {
          x: 72,
          y: 235
        },
        'Г-220': {
          x: 34,
          y: 235
        },

         'Flo11': {
          x: 85,
          y: 264
        },
        'Г-219f': {
          x: 72,
          y: 264
        },
        'Г-219': {
          x: 34,
          y: 264
        },

         'Flo12': {
          x: 85,
          y: 293
        },
         'Г-218f': {
          x: 72,
          y: 293
        },
        'Г-218': {
          x: 34,
          y: 293
        },

         'Flo13': {
          x: 85,
          y: 324
        },
         'Г-217f': {
          x: 72,
          y: 324
        },
        'Г-217': {
          x: 34,
          y: 324
        },

         'Flo14': {
          x: 85,
          y: 378
        },
         'Г-215f': {
          x: 72,
          y: 378
        },
        'Г-215': {
          x: 34,
          y: 376
        },
        'Г-216f': {
          x: 53,
          y: 364
        },
        'Г-216': {
          x: 34,
          y: 352
        },
        'Г-214f': {
          x: 53,
          y: 391
        },
        'Г-214': {
          x: 34,
          y: 401
        },

         'Flo15': {
          x: 85,
          y: 401
        },
        'Г-213f': {
          x: 85,
          y: 416
        },
        'Г-213': {
          x: 52,
          y: 444
        },

         'Flo16': {
          x: 116,
          y: 401
        },
          'Г-228f': {
          x: 116,
          y: 387
        },
         'Г-228': {
          x: 116,
          y: 360
        },
        'Г-212f': {
          x: 116,
          y: 416
        },
        'Г-212p': {
          x: 116,
          y: 429
        },
         'Г-212-1f': {
          x: 118,
          y: 442
        },
        'Г-212-1': {
          x: 137,
          y: 457
        },

         'Flo17': {
          x: 150,
          y: 401
        },
        'Г-229f': {
          x: 150,
          y: 387
        },
         'Г-229': {
          x: 150,
          y: 360
        },

         'Flo18': {
          x: 186,
          y: 401
        },
        'Г-230f': {
          x: 186,
          y: 387
        },
         'Г-230': {
          x: 186,
          y: 360
        },

         'Flo19': {
          x: 229,
          y: 401
        },
        'Г-231f': {
          x: 229,
          y: 387
        },
         'Г-231': {
          x: 229,
          y: 360
        },
        'Г-212f2': {
          x: 228,
          y: 416
        },
         'Г-212': {
          x: 200,
          y: 444
        },

         'Flo20': {
          x: 284,
          y: 401
        },
        'Г-211f': {
          x: 284,
          y: 417
        },
         'Г-211': {
          x: 274,
          y: 429
        },
        'Г-211-1f': {
          x: 274,
          y: 443
        },
         'Г-211-1': {
          x: 274,
          y: 457
        },

         'Flo21': {
          x: 310,
          y: 401
        },

         'Flo22': {
          x: 345,
          y: 401
        },

         'Flo23': {
          x: 370,
          y: 401
        },
         'Г-210f': {
          x: 370,
          y: 417
        },
         'Г-210': {
          x: 368,
          y: 449
        }, // установить длину 15
        'Г-210-1f': {
          x: 347,
          y: 432
        },
         'Г-210-1': {
          x: 323,
          y: 445
        },

         'Flo24': {
          x: 401,
          y: 401
        },
        'Г-209f': {
          x: 401,
          y: 417
        },
         'Г-209': {
          x: 401,
          y: 449
        },

         'Flo25': {
          x: 461,
          y: 401
        },
         'Г-208f': {
          x: 461,
          y: 417
        },
         'Г-208': {
          x: 498,
          y: 443
        },
         'Г-208-1f': {
          x: 446,
          y: 435
        },
         'Г-208-1': {
          x: 432,
          y: 449
        },

        'Flo26': {
          x: 461,
          y: 350
        },
        'Г-207f': {
          x: 476,
          y: 349
        },
         'Г-207': {
          x: 512,
          y: 361
        },
         'Г-207-1f': {
          x: 493,
          y: 385
        },
         'Г-207-1': {
          x: 512,
          y: 401
        },

        'Flo27': {
          x: 461,
          y: 310
        },
        'Г-206f': {
          x: 476,
          y: 310
        },
         'Г-206': {
          x: 512,
          y: 310
        },

        'Flo28': {
          x: 461,
          y: 233
        },
        'Г-205f': {
          x: 476,
          y: 233
        },
         'Г-205': {
          x: 512,
          y: 233
        },
         'Г-205-1f': {
          x: 493,
          y: 247
        },
         'Г-205-1': {
          x: 512,
          y: 268
        },

        'Flo29': {
          x: 461,
          y: 199
        },
         'Г-204f': {
          x: 476,
          y: 199
        },
         'Г-204': {
          x: 512,
          y: 199
        },

        'Flo31': {
          x: 461,
          y: 81
        },
        'Г-202f': {
          x: 476,
          y: 81
        },
        'Г-202': {
          x: 496,
          y: 36
        },
        'Г-202p': {
          x: 511,
          y: 77
        },
        'Г-202-1f': {
          x: 461,
          y: 66
        },
        'Г-202-1': {
          x: 461,
          y: 35
        },

        'Flo30': {
          x: 461,
          y: 116
        },
        'Г-203f': {
          x: 476,
          y: 116
        },
        'Г-203': {
          x: 512,
          y: 116
        },
        'Г-201f': {
          x: 447,
          y: 116
        },
        'Г-201': {
          x: 382,
          y: 116
        },
        'Г-201-1f': {
          x: 291,
          y: 97
        },
        'Г-201-1': {
          x: 275,
          y: 51
        },
        'Г-201-2f': {
          x: 365,
          y: 97
        },
        'Г-201-2': {
          x: 347,
          y: 51
        },
        'Г-201-3f': {
          x: 427,
          y: 97
        },
        'Г-201-3': {
          x: 414,
          y: 51
        },
        'Г-201-4f': {
          x: 308,
          y: 116
        },
        'Г-201-4': {
          x: 274,
          y: 116
        },


        'roof1': {
          x: 111,
          y: 144
        },
        'roof2': {
          x: 444,
          y: 144
        },
        'roof3': {
          x: 111,
          y: 333
        },
        'roof4': {
          x: 444,
          y: 333
        },

        'roof11': {
          x: 151,
          y: 144
        },
        'roof21': {
          x: 244,
          y: 144
        },
        'roof31': {
          x: 311,
          y: 144
        },
        'roof41': {
          x: 344,
          y: 144
        },

        'roof12': {
          x: 151,
          y: 333
        },
        'roof22': {
          x: 244,
          y: 333
        },
        'roof32': {
          x: 311,
          y: 333
        },
        'roof42': {
          x: 344,
          y: 333
        },

        'roof13': {
          x: 111,
          y: 170
        },
        'roof23': {
          x: 111,
          y: 270
        },
        'roof33': {
          x: 111,
          y: 200
        },
        'roof24': {
          x: 444,
          y: 270
        },
        'roof34': {
          x: 444,
          y: 200
        },
        'roof44': {
          x: 444,
          y: 270
        },

        'stairs1': {
          x: 36,
          y: 151
        },
        'stairs1f': {
          x: 84,
          y: 151
        },
        'stairs2': {
          x: 510,
          y: 151
        },
        'stairs2f': {
          x: 461,
          y: 151
        },
        'stairs3': {
          x: 274,
          y: 365
        },

        'wc': {
          x: 310,
          y: 360
        },
      };

      this.mapCoord = coordinates;
// датчики ниже
      let sensors = {
        'sen_1': {
          x: 240, 
          y: 69
        },
        'sen_2': {
          x: 200,
          y: 97
        },
        'sen_3': {
          x: 164, 
          y: 69
        },
        'sen_4': {
          x: 126, 
          y: 97
        },
        'sen_5': {
          x: 102, 
          y: 69
        },
        'sen_6': {
          x: 72, 
          y: 34
        },
         'sen_7': {
          x: 72, 
          y: 112
        },
         'sen_8': {
          x: 103, 
          y: 148
        },
         'sen_9': {
          x: 72, 
          y: 187
        },
        'sen_10': {
          x: 103, 
          y: 148
        },
         'sen_11': {
          x: 72, 
          y: 187
        },
        'sen_12': {
          x: 103, 
          y: 148
        },
         'sen_13': {
          x: 72, 
          y: 187
        },


        'sen227_1': {
          x: 238, 
          y: 103
        },
        'sen227_2': {
          x: 173,
          y: 134
        },
        'sen227_3': {
          x: 238, 
          y: 134
        },
        'sen227-2_1':{
          x: 210, 
          y: 8
        },
        'sen227-2_2':{
          x: 238, 
          y: 8
        },
        'sen227-2_3':{
          x: 238, 
          y: 64
        },
        'sen227-1_1':{
          x: 174, 
          y: 8
        },
        'sen227-1_2':{
          x: 202, 
          y: 8
        },
        'sen227-1_3':{
          x: 202, 
          y: 64
        },

        'sen226_1': {
          x: 166, 
          y: 103
        },
        'sen226_2': {
          x: 107,
          y: 134
        },
        'sen226_3': {
          x: 169, 
          y: 134
        },
        'sen226-2_1':{
          x: 170, 
          y: 8
        },
        'sen226-2_2':{
          x: 140, 
          y: 8
        },
        'sen226-2_3':{
          x: 170, 
          y: 64
        },
        'sen226-1_1':{
          x: 106, 
          y: 8
        },
        'sen226-1_2':{
          x: 134, 
          y: 8
        },
        'sen226-1_3':{
          x: 134, 
          y: 64
        },

         'sen225_1': {
          x: 99, 
          y: 8
        },
        'sen225_2': {
          x: 6,
          y: 8
        },
        'sen225_3': {
          x: 6, 
          y: 31
        },
            
        'sen224_1': {
          x: 69, 
          y: 39
        },
        'sen224_2': {
          x: 6,
          y: 36
        },
        'sen224_3': {
          x: 6, 
          y: 96
        },

        'sen223_1': {
          x: 69, 
          y: 103
        },
        'sen223_2': {
          x: 6,
          y: 103
        },
        'sen223_3': {
          x: 6, 
          y: 137
        },  
// прописаны выше

      };
      this.sensCoord = sensors;
      
      return graph
    },

    // новая фунуция которая будет  потгружать map   
    // строит граф  
    graphFine: function () {
      var graph = this.graphSave()
      // библиотечка
      let path = require('ngraph.path');
      let pathFinder = path.aStar( graph, {
        // We tell our pathfinder what should it use as a distance function:
        distance(fromNode, toNode, link) {
          // We don't really care about from/to nodes in this case,
          // as link.data has all needed information:
          return link.data.weight;
        }
      });
      // от - до строит маршрут
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