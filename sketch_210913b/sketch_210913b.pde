Piece[] piece;
PFont myFont;
int a = 5;
boolean p = false;
void setup(){
  size( 550, 650 );
  
  piece = new Piece[10];
  piece[0] = new Piece( a, a, "王" );
  piece[0].place( int(a*2/3 + 1/2), int(a*2/3 + 1/2) );
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

void draw(){
  background( 255 );
  Piece p = piece[0];
  
  board();
  p.start_move();
  p.control( mouseX, mouseY, mousePressed );
  p.draw();
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
  int bx, by;
  float x, y, size, block;
  String name;
  boolean follow, drag;
  Piece(int _x, int _y, String _name){
    name = _name;
    block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    bx = int( x / block );
    by = int( y / block );
    follow = false;
    drag   = false;
  }
  
  public void draw(){
    fill( 255 );
    stroke( follow ? color( 255, 0, 0 ) : color( 0 ) );
    circle( x, y, size );
    fill( 0 );
    textSize( 16 );
    text( name, x - textWidth(name)/2, y + textWidth(name)/4 );
  }
  
  public void place( float tx, float ty ){
    p = false;
    int rx = int( tx / block ),
        ry = int( ty / block );
    println( rx, ry );
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
  
  public void start_move(){
    if ( p == false ){
       p = true;
       bx = int(x / block);
       by = int(y / block);
    }
   }
  
  public void control( float tx, float ty, boolean _drag ){
    if( _drag && sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2 ){
       follow = true;
    }else if( !_drag && follow ){
      println( bx, by, tx, ty );
      follow = false;
      if ( int( ty / block ) == 6 )
        place( bx, by );
      else
        place( tx, ty );
    }
    
    if( follow ){
      x = tx;
      y = ty;
    }
  }
};
