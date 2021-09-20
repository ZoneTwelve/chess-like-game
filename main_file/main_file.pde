Piece[] piece;
PFont myFont;
String[] p_name = {"王", "金", "木", "土", "水", "火", "卒", "士"};
int team1_start[][] = { {8, 2} , {7, 2} , {9, 2} , {5, 2} , {11, 3} , {5, 3} , {11, 2} , {2, 2} , {12, 2} , {3, 2} , {14, 2} , {2, 7} , {5, 7} , {8, 7} , {11, 7} , {14, 7} };
int team2_start[][] = { {8, 17} ,  {7, 17} , {9, 17} , {5, 16} , {11, 17} , {5, 17} , {11, 16} , {3, 17} , {14, 17} , {2, 17} , {12, 17} , {2, 12} , {5, 12} , {8, 12} , {11, 12} , {14, 12}};
int hp_start[] = { 2, 2, 1, 3, 2, 2, 2, 2};
int solder_id[]  = { 11, 12, 13, 14, 15, 27, 28, 29, 30, 31 };
int piece_start[][][] = { team1_start, team2_start };
int board[][] = new int[9][11];
// 王: 8,2 ; 8,17
// 金: 7/9,2 ; 7/9,17
// 木: 5,16 11,17 ; 
// 土: 5,17 11,16 ; 
// 水 2/12,17
// 火: 4/
// 卒: 
boolean p = false;
final int block = 50;
void setup(){
  size( 550, 650 );
  
  // init board[][]
  for(int a=0; a<9; a++){
    for(int b=0; b<11; b++){
      board[a][b] = -1;
    }
  }
  
  // add piece loop
  piece = new Piece[32];
  int index = 0;
  for( int i = 0; i < piece_start.length; i++ ){
    int n = 0, s = 0;
    for( int j = 0; j <  piece_start[i].length; j++){
      board[ int(piece_start[i][j][0]*2/3 + 1/2) - 1][ int(piece_start[i][j][1]*2/3 + 1/2) - 1 ] = index;
      if( j == 0 ){
        piece[index] = set_piece( p_name[n], piece_start[i][j][0], piece_start[i][j][1] , i+1, index, hp_start[n]);
      }
      else if( j < 11 ){
        s += 1;
        if( s == 2 ){
          s = 0;
        }
        piece[index] = set_piece( p_name[n+s], piece_start[i][j][0], piece_start[i][j][1] , i+1, index, hp_start[n+s]);
        n = n + s;
      }
      else{
        piece[index] = set_piece( p_name[n+i+1], piece_start[i][j][0], piece_start[i][j][1] , i+1, index, hp_start[n+i+1]);
      }
      index++;
    }
  }
  

  
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

Piece set_piece( String name, int x, int y, int team , int index, int hp){
  Piece p = new Piece( x, y, name, team, index , hp);
  p.place( int(x*2/3 + 1/2), int(y*2/3 + 1/2) );
  return p;
}

void draw(){
  background( 255 );
  
  draw_board();

  for( int i = 0; i < piece.length; i++ ){
    Piece p = piece[ i ]; 
    int rx = int( mouseX / block ), ry = int( mouseY / block );
    int pindex = -1;
    if( p.life == true ){
      Piece tmp_p = null;
      if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
        pindex = board[ rx - 1 ][ ry - 1 ];
      }
  
      if( pindex > -1 ){
        tmp_p = piece[ pindex ];
      }
      
      int prx = int( p.x / block ), pry = int( p.y / block );
      int pprx = int( p.px / block ), ppry = int( p.py / block );
      boolean pfollow = p.follow==true;
      p.control( mouseX, mouseY, mousePressed, pindex == i ? null : tmp_p );
  
      if( !mousePressed && pfollow && p.hover && !p.has_attack){
        println( prx, pry, pprx, ppry);
        board[ prx - 1 ][ pry - 1 ] ^= board[ pprx - 1 ][ ppry - 1 ];
        board[ pprx - 1 ][ ppry - 1 ] ^= board[ prx - 1 ][ pry - 1 ];
        board[ prx - 1 ][ pry - 1 ] ^= board[ pprx - 1 ][ ppry - 1 ];
      }
      
      p.draw();
    }
    else{
      int prx = int( p.x / block ), pry = int( p.y / block );
      board[ prx - 1 ][ pry - 1 ] = -1;
    }
  }
  
  
}

void draw_board(){
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
  int step;
  int team, id, hp;
  float x, y, px, py, // [x, y](currect), [px, py](previous)  
        size;  // piece size, block size
  String name;
  boolean follow = false, drag = false, hover = false, life = true, has_attack = false;
  Piece(int _x, int _y, String _name, int _team, int _id, int _hp){
    name = _name;
    //block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    px = -1;
    py = -1;
    step = 0;
    team = _team;
    id = _id;
    hp = _hp;
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
    //p = false;
    int rx = int( tx / block ),
        ry = int( ty / block );
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }  
  public void place( int rx, int ry ){
    //p = false;
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }
  
  public void control( float tx, float ty, boolean _drag, Piece tp ){
    if( !_drag )
      hover = sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2;

    if( !follow && _drag && hover ){
      px = x;
      py = y;
      follow = true;
    }else if( !_drag && follow && hover ){
      follow = false;
      println( tp ); // target piece
      //if ( (!moving_rule( int(tx), int(ty) ) || int( ty / block ) == 6) || tp != null ){
      if ( (tp != null && tp.team == team ) || (!moving_rule( int(tx), int(ty) ) || int( ty / block ) == 6) ){
        println("can't move", step);
        place( px, py );
      }
      else if( moving_rule( int(tx), int(ty))  &&  tp != null && tp.team != team){  //attack
        print("attack hp-1", tp.hp);
        has_attack = true;
        tp.hp -= 1;
        if ( tp.hp == 0 ){
          tp.life = false;
          place( tx, ty );
        }
        else{
          place( px, py );
        }
        print(" >> ", tp.hp, tp.life, "\n");
      }
      else{
        println("move", step);
        for( int i=0; i<solder_id.length; i++ ){
          if(id == solder_id[i]){
            step -= 1;
            break;
          }
        }
        place( tx, ty );
      }
    }
    
    if( follow ){
      x = tx;
      y = ty;
    }
  }
  
  public void attack(){
    
  }
  
  public boolean moving_rule( int tx, int ty ){
    boolean result = false;
    int bx  = int(px/block) , // input base position 
        by  = int(py/block) ,
        tbx = int(tx/block) ,
        tby = int(ty/block) ; // block based
        
       
    switch( name ){
      case "王":
        if( abs(tbx-bx) <= 1 && ( abs(tby-by) <= 1 || (tby==5 && by==7) || (tby==7 && by==5) ) )
          result = true;
      break;
      case "金":
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
      break;
      case "土":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case "水":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case "火":
        if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) )){
          result = true;
        }
      break;
      case "卒":
        if( step==0 || step==1 ){  //before cross river
          if( tbx-bx==0 && ( tby-by==1 || ( tby==5 && by==7 ) || ( tby==7 && by==5 ) ) ){
            result = true;
          }
        }
        else{  //after cross river
          if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) ) ){
            result = true;
          }
        }
      break;
      case "士":
        if( step==0 || step==1 ){  //before cross river
          if( tbx-bx==0 && ( tby-by==-1 || ( tby==5 && by==7 ) || ( tby==7 && by==5 ) ) ){
            result = true;
          }
        }
        else{  //after cross river
          if( (abs(tbx-bx)==1 && tby-by==0) || (tbx-bx==0 && abs(tby-by)==1)  || ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5)  ) ) ){
            result = true;
          }
        }
      break;
    }
    if( result == true )
      step ++;

    println("step:", step);

    return result;
  }
};
