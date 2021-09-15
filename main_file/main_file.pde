Piece[] piece;
PFont myFont;
String[] p_name = {"王", "金", "木", "土", "水", "火", "卒"};
int king_start[][] = { {8, 2} , {8, 17} };
int gold_start[][] = { {7, 2} , {7, 17} ,  {9, 2} , {9, 17} };
int wood_start[][] = { {5, 2} , {5, 16} ,  {11, 3} , {11, 17} };
int earth_start[][] = { {5, 3} , {5, 17} ,  {11, 2} , {11, 16} };
int water_start[][] =  { {2, 2} , {3, 17} ,  {12, 2} , {14, 17} };
int fire_start[][] =  { {3, 2} , {2, 17} ,  {14, 2} , {12, 17} };
int solder_start[][] =  { {2, 7} , {5, 7} , {8, 7} , {11, 7} , {14, 7} , {2, 12} , {5, 12} , {8, 12} , {11, 12}, {14, 12} };
int piece_start[][][] = { king_start, gold_start , wood_start, earth_start, water_start, fire_start, solder_start};
// 王: 8,2 ; 8,17
// 金: 7/9,2 ; 7/9,17
// 木: 5,16 11,17 ; 
// 土: 5,17 11,16 ; 
// 水 2/12,17
// 火: 4/
// 卒: 
int a = 8;
int b = 17;
boolean p = false;
void setup(){
  size( 550, 650 );
  // add piece loop
  piece = new Piece[32];
  int index = 0;
  for( int i = 0; i < piece_start.length; i++ ){
    for( int j = 0; j <  piece_start[i].length; j++){
      piece[index] = set_piece( p_name[i], piece_start[i][j][0], piece_start[i][j][1] );
      index++;
    }
  }
  
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

Piece set_piece( String name, int x, int y ){
  Piece p = new Piece( x, y, name );
  p.place( int(x*2/3 + 1/2), int(y*2/3 + 1/2) );
  return p;
}

void move_control_draw( Piece p ){
  p.control( mouseX, mouseY, mousePressed );
  p.draw();
}

void draw(){
  background( 255 );
  
  board();

  for( int i = 0; i < piece.length; i++ ){
    move_control_draw( piece[i] ); 
  }
  
  
}

void board(){
  int size = 50;
  stroke( 0 );
  for( int y = 1 ; y <= 11 ; y++ ){
    for( int x = 1 ; x <= 9 ; x++){
      fill( 255 );
      if( y==6 )
        fill( 200, 200, 240 );
      rect( x * size, y * size, size, size );
    }
  }
}

public class Piece{
  int bx, by, step;
  float x, y, px, py, // [x, y](currect), [px, py](previous)  
        size, block;  // piece size, block size
  String name;
  boolean follow = false, drag = false, hover = false;
  Piece(int _x, int _y, String _name){
    name = _name;
    block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    px = -1;
    py = -1;
    bx = int( x / block );
    by = int( y / block );
    step = 0;
  }
  
  public void draw(){
    fill( 255 );
    stroke( follow ? color( 255, 0, 0 ) : hover ? color( 250, 100, 100 ) : color( 0 ) );
    circle( x, y, size );
    fill( 0 );
    textSize( 16 );
    text( name, x - textWidth(name)/2, y + textWidth(name)/4 );
  }
  
  public void place( float tx, float ty ){
    p = false;
    int rx = int( tx / block ),
        ry = int( ty / block );
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }  
  public void place( int rx, int ry ){
    p = false;
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }
  
  public void control( float tx, float ty, boolean _drag ){
    if( !_drag )
      hover = sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2;

    if( !follow && _drag && hover ){
      px = x;
      py = y;
      follow = true;
    }else if( !_drag && follow && hover ){
      follow = false;
      if ( !moving_rule( int(tx), int(ty) ) || int( ty / block ) == 6 ){
        place( px, py );
      }else{
        place( tx, ty );
      }
    }
    
    if( follow ){
      x = tx;
      y = ty;
    }
  }
  
  public boolean moving_rule( int tx, int ty ){
    boolean result = false;
    int bx  = int(px/block) , // input base position 
        by  = int(py/block) ,
        tbx = int(tx/block) ,
        tby = int(ty/block) ; // block based
    switch( name ){
      case "王":
        //print("Pos: ");
        //println(abs(tbx-bx), abs(tby-by), abs(tbx-bx) <= 1 && abs(tbx-bx) <=1, tbx, tby, bx, by);
        if( abs(tbx-bx) <= 1 && ( abs(tby-by) <= 1 || (tby==5 && by==7) || (tby==7 && by==5) ) )
          result = true;
      break;
      case "金":
        print("Pos: ");
        println(abs(tbx-bx), abs(tby-by), abs(tbx-bx) <= 1 && abs(tbx-bx) <=1, tbx, tby, bx, by);
        if( step == 0 ){
           if( ( abs(tbx-bx) <= 3 && tby-by==0 ) || ( abs(tby-by) <= 3 && tbx-bx==0 ) ) 
             result = true;
        }
        else{
          if( ( abs(tbx-bx) <= 2 && tby-by==0 ) || ( abs(tby-by) <= 2 && tbx-bx==0 ) ||  ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5) )) )
            result = true;
        }
      break;
      case "木":
        if( ( abs(tbx-bx)==1 && abs(tby-by)==1 ) || ( abs(tbx-bx)==1 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) ) ){
          result = true;
        }
        //print("Pos: ");
        //println(abs(tbx-bx), abs(tby-by), abs(tbx-bx) <= 1 && abs(tbx-bx) <=1, bx, by, tbx, tby, result);
      break;
      case "土":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( abs(tbx-bx)==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case "水":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( abs(tbx-bx)==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case "火":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( abs(tbx-bx)==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case"卒":
        if( step==0 || step==1 ){  //before cross river
          
        }
        else{
          if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( abs(tbx-bx)==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
            result = true;
          }
        }
      break;
    }
    if( result == true )
      step ++;
    return result;
  }
};
