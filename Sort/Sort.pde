import java.util.Stack;
enum Mode{
    TITLE,
    SORT,
}

Mode mode = Mode.TITLE;

String sortNames[] = {
    "Bubble Sort",
    "Shaker Sort",
    "Insertion Sort",
    "Shell Sort",
    "Quick Sort"
};
final boolean allowChangeFrameRate = false;
final boolean drawFrameRateFlag = true;
final boolean dataIsInteger = true;
final boolean drawComputingCost = true;

int numOfSort = 5;

int numberOfData = 1000;
color litblu = color(200,200,255);
color red = color(255,50,50);
color blu = color(20,20,255);
color gre = color(60,255,60);
color gra = color(190);
WindowPanel panel;
long countCost = 0;
int framerate = 60;
int speedZoom = 1;

boolean pauseFlag = false;
boolean key_down = false;
boolean key_up = false;


void keyPressed() {
    if (keyCode == UP) key_up = true;
    if (keyCode == DOWN) key_down = true;
    if (key == 'r') changeToTitle();
    if (key == 'p') {
        pauseFlag = !pauseFlag;
        if (pauseFlag)noLoop();
        else loop();
    }
}
void keyReleased() {
    if (keyCode == UP) key_up = false;
    if (keyCode == DOWN) key_down = false;
}
public class Meter{
    private int underX;
    private int underY;
    private int length;
    private float value;
    private float valueMin;
    private float valueMax;
    private float barWidth;
    private String name;
    
    public Meter(int x,int y,float value,String name,float vmax,float vmin) {
        this.underX = x;
        this.underY = y;
        this.length = 600;
        this.value = value;
        
        this.valueMax = vmax;
        this.valueMin = vmin;
        
        this.barWidth = 30;
        this.name = name;
    }
    public Meter(int x,int y,float value,float vmax,float vmin) {
        this(x,y,value,"",vmax,vmin);
    }
    public float getValue() {
        return this.value;
    }
    private void changeValue() {
        if (mousePressed) {
            if (mouseX < underX - barWidth / 2) return;
            if (underX + barWidth / 2 < mouseX) return;
            if (mouseY < underY - length) return;
            if (underY < mouseY) return;
            float pointY = mouseY;
            pointY -= (underY - length);
            pointY = length - pointY;
            this.value = map(pointY,0,length,this.valueMin,this.valueMax);
        }
    }
    
    private void draw() {
        stroke(0);
        strokeWeight(3);
        pushMatrix();
        translate(underX,underY);
        line(0,0,0, -length);
        
        float valueHeightY = map(value,valueMin,valueMax,0,length);
        stroke(red);
        strokeWeight(5);
        line( -barWidth / 2, -valueHeightY,barWidth / 2, -valueHeightY);
        
        textAlign(CENTER,CENTER);
        textSize(50);
        fill(0);
        text((int)value,0,30);
        
        text(name,0, -length - 50);
        
        popMatrix();
        
    }
    public void update() {
        this.changeValue();
        this.draw();
    }
    
    
}
abstract class WindowPanel{
    abstract void draw();
    abstract void update();
}
public class SortPanel extends WindowPanel{
    
    protected int numOfData;
    protected float value[];
    private int sideSpace;
    private float barWidth;
    private float barZoomRate;
    private boolean activeFlag;
    
    public SortPanel() {
        this.numOfData = numberOfData;
        this.value = new float[numOfData];
        if (dataIsInteger) {
            this.setValueInteger();
        } else {
            this.setValueFloat();
        }
        this.barWidth = width / numOfData;
        
        this.sideSpace = (width % numOfData) / 2;

        if(numberOfData > 300) {
            sideSpace = 1;
            this.barWidth = width / (float)numOfData;
        }
        this.barZoomRate = (height - 100) / (float)numOfData;
        
        activeFlag = true;
    }
    protected void setValueInteger() {
        float valueDraft[] = new float[numOfData];
        boolean valueFlag[] = new boolean[numOfData];
        for (int i = 0;i < numOfData;i++) {
            valueDraft[i] =  random(numOfData);
            valueFlag[i] = false;
        }
        for (int i = 0;i < numOfData;i++) {
            int valueI = (int)valueDraft[i];
            while(valueFlag[valueI]) {
                valueI += 1;
                valueI %= numOfData;
            }
            valueFlag[valueI] = true;
            this.value[i] = valueI + 1;
        }
    }
    protected void setValueFloat() {
        for (int i = 0;i < numOfData;i++) {
            value[i] = random(1,numOfData + 1);
        }
    }
    protected void swap(int a,int b) {
        float tem = value[a];
        value[a] = value[b];
        value[b] = tem;
    }
    protected boolean sorted() {
        boolean flag = true;
        for (int i = 0;i < numOfData - 1;i++) {
            if (value[i] > value[i + 1]) flag = false;
        }
        return flag;
    }
    private void changeFrameRate() {
        if (keyPressed) {
            if (keyCode == UP)frameRate(framerate += 5);
            if (keyCode == DOWN)frameRate(framerate -= 5);
        }
    }
    public void draw() {
        pushMatrix();
        translate(sideSpace,height);
        strokeWeight(2);
        stroke(0);
        fill(red);
        if (this.sorted()) fill(blu);
        for (int i = 0;i < numOfData;i++) {
            if (numOfData > 200) {
                strokeWeight(1);
                ellipse(0, - this.value[i] * this.barZoomRate,5,5);
            }
            else {
                rect(0,0,this.barWidth - 1, -this.value[i] * this.barZoomRate);
            }
            translate(this.barWidth,0);
        }
        popMatrix();
    }
    public void draw(int[] coloredDataIndexs) {
        boolean[] coloredDataFlag = new boolean[this.numOfData];
        for (int i = 0;i < this.numOfData;i++) {
            coloredDataFlag[i] = false;
        }
        for (int i : coloredDataIndexs) {
            if (i < 0 || numOfData <= i) continue;
            coloredDataFlag[i] = true;
        }
        color defColor = red;
        color chkColor = gre;
        color endColor = blu;
        
        pushMatrix();
        translate(sideSpace,height);
        strokeWeight(2);
        stroke(0);
        for (int i = 0;i < numOfData;i++) {
            if (sorted()) {
                fill(endColor);
            }
            else if (coloredDataFlag[i]) {
                fill(chkColor);
            }
            else {
                fill(defColor);
            }
            
            if (numOfData > 200) {
                strokeWeight(1);
                ellipse(0, - this.value[i] * this.barZoomRate,5,5);
            }
            else {
                rect(0,0,this.barWidth - 1, -this.value[i] * this.barZoomRate);
            }
            translate(this.barWidth,0);
        }
        popMatrix();
    }
    public void draw(int[] mainColoredIndexs,int[] subColoredIndexs) {
        boolean[] mainColoredDataFlag = new boolean[this.numOfData];
        boolean[] subColoredDataFlag = new boolean[this.numOfData];
        for (int i = 0;i < this.numOfData;i++) {
            mainColoredDataFlag[i] = false;
            subColoredDataFlag[i] = false;
        }
        for (int i : mainColoredIndexs) {
            if (i < 0 || numOfData <= i) continue;
            mainColoredDataFlag[i] = true;
        }
        for (int i : subColoredIndexs) {
            if (i < 0 || numOfData <= i) continue;
            subColoredDataFlag[i] = true;
        }
        color defColor = gra;
        color mainColor = red;
        color subColor = gre;
        color endColor = blu;
        
        pushMatrix();
        translate(sideSpace,height);
        strokeWeight(2);
        stroke(0);
        boolean sortedFlag = sorted();
        for (int i = 0;i < numOfData;i++) {
            if (sortedFlag) {
                fill(endColor);
            }
            else if (mainColoredDataFlag[i]) {
                fill(mainColor);
            }
            else if (subColoredDataFlag[i]) {
                fill(subColor);
            }
            else {
                fill(defColor);
            }
            
            if (numOfData > 200) {
                strokeWeight(1);
                ellipse(0, - this.value[i] * this.barZoomRate,5,5);
            }
            else {
                rect(0,0,this.barWidth - 1, -this.value[i] * this.barZoomRate);
            }
            translate(this.barWidth,0);
        }
        popMatrix();
    }
    public void update() {
        for (int i = 0;i < speedZoom;i++) {
            if (this.activeFlag) {
                this.sort();
                countCost++;
                if (sorted()) this.activeFlag = false;
            }
            if (allowChangeFrameRate) {
                this.changeFrameRate();
            }
        }
    }
    
    public void sort() {}
    
}
public class BubbleSortPanel extends SortPanel{
    private int checkingDataIndex;
    private int rightSide;
    private int lastChange;
    public BubbleSortPanel() {
        super();
        this.checkingDataIndex = this.numOfData - 2;
        this.rightSide = numOfData - 1;
        this.lastChange = numOfData - 1;
    }
    public void draw() {
        int[] checkingDataIndexs = {
            this.checkingDataIndex,
            this.checkingDataIndex + 1
        };
        super.draw(checkingDataIndexs);
    }
    public void sort() {
        this.checkingDataIndex += 1;
        this.checkingDataIndex %= (rightSide);
        if (checkingDataIndex == 0) rightSide = lastChange;
        if (value[checkingDataIndex] > value[checkingDataIndex + 1]) {
            swap(checkingDataIndex,checkingDataIndex + 1);
            lastChange = checkingDataIndex;
        }
    }
}
public class ShakerSortPanel extends SortPanel{
    private int checkingDataIndex;
    private boolean moveRight;
    private int leftSide;
    private int rightSide;
    private int lastChange;
    public ShakerSortPanel() {
        super();
        this.checkingDataIndex = -1;
        this.moveRight = true;
        this.leftSide = 0;
        this.rightSide = this.numOfData - 2;
        this.lastChange = 0;
    }
    public void draw() {
        int[] checkingDataIndexs = {
            this.checkingDataIndex,
            this.checkingDataIndex + 1
        };
        super.draw(checkingDataIndexs);
    }
    public void sort() {
        if (moveRight) {
            this.checkingDataIndex++;
            if (checkingDataIndex == rightSide) {
                moveRight = false;
                rightSide = lastChange;
            }
        } else {
            this.checkingDataIndex--;
            if (this.checkingDataIndex == leftSide) {
                moveRight = true;
                leftSide = lastChange;
            }
        }
        if (value[checkingDataIndex] > value[checkingDataIndex + 1]) {
            this.swap(checkingDataIndex,checkingDataIndex + 1);
            lastChange = checkingDataIndex;
        }
    }
}
public class InsertionSortPanel extends SortPanel{
    private int sortedIndex;
    private int checkingDataIndex;
    public InsertionSortPanel() {
        super();
        this.sortedIndex = 0;
        this.checkingDataIndex = this.sortedIndex + 1;
    }
    public void draw() {
        int[] checkingDataIndexs = {checkingDataIndex};
        super.draw(checkingDataIndexs);
    }
    public void sort() {
        if (checkingDataIndex == 0) {
            this.sortedIndex++;
            this.checkingDataIndex = this.sortedIndex + 1;
        }
        else if (value[checkingDataIndex] < value[checkingDataIndex - 1]) {
            this.swap(checkingDataIndex,checkingDataIndex - 1);
            checkingDataIndex--;
        } else {
            this.sortedIndex++;
            this.checkingDataIndex = this.sortedIndex + 1;
        }
    }
}
public class ShellSortPanel extends SortPanel{
    private int intervalIndex;
    private int[] intervalList;
    private int count;
    private int checkingDataIndex;
    private int sortedIndex;
    public ShellSortPanel() {
        super();
        this.intervalList = new int[]{
            //19,17,15,13,11,9,7,5,3,1
            //33,30,27,24,21,18,15,13,10,7,4,1
            364,121,40,13,4,1
        };
        this.setInterval();
        this.sortedIndex = 0;
        this.count = 0;
        this.checkingDataIndex = intervalList[intervalIndex];
    }
    //間隔の決め方（以下参照）
    //https://programming-place.net/ppp/contents/algorithm/sort/005.html#select_gap
    //ちょっと数字をいじった
    private void setInterval() {
        intervalIndex = 0;
        while(numOfData / 9  + 1 < intervalList[intervalIndex])intervalIndex++;
    }
    public void draw() {
        int interval = intervalList[intervalIndex];
        int mainColored[] = {checkingDataIndex};
        int subColored[] = new int[numOfData];
        for (int i = 0;i < numOfData;i++) {
            subColored[i] = -1;
        }
        int index = 0;
        for (int i = count;i < numOfData;i += interval) {
            subColored[index++] = i;
        }
        
        super.draw(mainColored,subColored);
        
    }
    public void sort() {
        int interval = intervalList[intervalIndex];
        
        if (checkingDataIndex / interval == 0) {
            sortedIndex += interval;
            checkingDataIndex = sortedIndex + interval;
            
            if (checkingDataIndex >= numOfData) {
                count += 1;
                if (count == interval) {
                    intervalIndex++;
                    count = 0;
                }
                interval = intervalList[intervalIndex];
                sortedIndex = count;
                checkingDataIndex = sortedIndex + interval;
            }
        }
        else if (value[checkingDataIndex] < value[checkingDataIndex - interval]) {
            swap(checkingDataIndex,checkingDataIndex - interval);
            checkingDataIndex -= interval;
        }
        else {
            sortedIndex += interval;
            checkingDataIndex = sortedIndex + interval;
            
            if (checkingDataIndex >= numOfData) {
                count += 1;
                if (count == interval) {
                    intervalIndex++;
                    count = 0;
                }
                interval = intervalList[intervalIndex];
                sortedIndex = count;
                checkingDataIndex = sortedIndex + interval;
            }
        }
    }
}
public class QuickSortPanel extends SortPanel{
    Stack<Integer> stackOfRange;  
    private float pivotValue;
    private int begin;
    private int end;
    private int left;
    private int right;
    private boolean swapFlag;
    private boolean checkingLeft;
    public QuickSortPanel() {
        super();
        stackOfRange = new Stack<Integer>();
        begin = 0;
        end = numOfData - 1;
        left = begin;
        right = end;
        this.setPivot();
        checkingLeft = true;
        swapFlag = false;
    }
    private void setPivot() {
        //this.pivotValue = value[this.begin];
        float first,second,third;
        first = value[this.begin];
        second = value[this.end];
        third = value[(this.begin + this.end) / 2];
        if (first <= second) {
            if (second <= third) pivotValue = second;
            else if (first <= third) pivotValue = third;
            else pivotValue = first;
        } 
        else {
            if (first <= third) pivotValue = first;
            else if (second <= third) pivotValue = third;
            else pivotValue = second;
        }
    }
    public void draw() {
        
        int mainColored[] = new int[this.end - this.begin + 1];
        int subColored[] = {this.left,this.right};
        int index = 0;
        for (int i = this.begin;i <= this.end;i++) {
            if (i == this.left || i == this.right) mainColored[index++] = -1;
            else mainColored[index++] = i;
        }
        //int mainColored[] = {left};
        //int subColored[] = {right};
        super.draw(mainColored,subColored);
    }
    public void sort() {
        if (right < left) {
            swapFlag = false;
            if (this.end - this.begin > 1) {
                stackOfRange.push(this.end);
                stackOfRange.push(this.left);
                stackOfRange.push(this.right);
                stackOfRange.push(this.begin);
            }
            if (stackOfRange.empty()) return;
            this.begin = stackOfRange.pop();
            this.end = stackOfRange.pop();
            this.left = this.begin;
            this.right = this.end;
            this.setPivot();
        }
        /*
        if (this.end - this.begin == 1) {
        if (value[this.end] < value[this.begin]) swap(this.begin,this.end);
        int tem = this.right;
        this.right = this.left;
        this.left = tem;
        return;
    }
        */
        if (swapFlag) {
            swapFlag = false;
            swap(left,right);
            
        }
        if (checkingLeft) {
            if (value[left] >= pivotValue) {
                checkingLeft = false;
                return;
            }
            left++;
        }
        else {
            if (value[right] < pivotValue) {
                checkingLeft = true;
                swapFlag = true;
                return;
            }
            right--;
        }
    }
}
public class TitleWindow extends WindowPanel{
    private String titleMsg;
    private float titleMsgX;
    private float titleMsgY;
    private float titleMsgSize;
    
    private float sortNamesListX;
    private float sortNamesListY;
    private float sortNameSize;
    private float sortNameSpace;
    
    private int selecting;
    
    private Meter dataMeter;
    private Meter speedMeter;
    
    public TitleWindow() {
        this.titleMsg = "Sort Algorithm";
        this.titleMsgX = width / 4;
        this.titleMsgY = height / 5;
        this.titleMsgSize = 60;
        
        this.sortNamesListX = width / 5;
        this.sortNamesListY = height / 3;
        this.sortNameSize = 40;
        this.sortNameSpace = this.sortNameSize + 5;   
        
        this.selecting = 0;
        
        this.dataMeter = new Meter(width * 2 / 3,height * 9 / 10,numberOfData,"Data",1000,10);
        this.speedMeter = new Meter(width * 2 / 3 + 180,height * 9 / 10,speedZoom,"speed",30,1);
        
    }
    public void update() {
        if (key_up) {
            selecting--;
            key_up = false;
        }
        if (key_down) {
            selecting++;
            key_down = false;
        }
        selecting = (selecting + numOfSort) % numOfSort;
        
        if (keyPressed) {
            if (key == 'z')
                switch(selecting) {
                case 0:
                    changeToBubbleSort();
                    break;
                case 1:
                    changeToShakerSort();
                    break;
                case 2:
                    changeToInsertionSort();
                    break;
                case 3:
                    changeToShellSort();
                    break;
                case 4:
                    changeToQuickSort();
                    break;
            }
        }
        this.dataMeter.update();
        numberOfData = (int)this.dataMeter.getValue();
        this.speedMeter.update();
        speedZoom = (int)this.speedMeter.getValue();
    }
    public void draw() {
        drawMsg(this.titleMsg,this.titleMsgX,this.titleMsgY,this.titleMsgSize);
        drawSortNames();
        drawSelecting();
    }
    
    private void drawSortNames() {
        for (int i = 0;i < numOfSort;i++) {
            pushMatrix();
            translate(sortNamesListX,sortNamesListY);
            translate(0,sortNameSpace * i);
            drawMsg(sortNames[i],0,0,sortNameSize);
            
            popMatrix();
        }
    }
    private void drawSelecting() {
        strokeWeight(2);
        stroke(red);
        int tem = 2;
        
        pushMatrix();
        translate(0,sortNamesListY);
        translate(0,sortNameSpace * selecting);
        line(0, -tem,width, -tem);
        translate(0,sortNameSpace);
        line(0,tem,width,tem);
        popMatrix();
    }
    private void drawMsg(String msg,float x,float y,float size) {
        fill(0);
        textSize(size);
        textAlign(CENTER,TOP);
        text(msg,x,y);
    }
}
void changeToTitle() {
    mode = Mode.TITLE;
    panel = new TitleWindow();
    countCost = 0;
}
void changeToSort() {
    mode = Mode.SORT;
    panel = new SortPanel();
}
void changeToBubbleSort() {
    mode = Mode.SORT;
    panel = new BubbleSortPanel();
}
void changeToShakerSort() {
    mode = Mode.SORT;
    panel = new ShakerSortPanel();
}
void changeToInsertionSort() {
    mode = Mode.SORT;
    panel = new InsertionSortPanel();
}
void changeToShellSort() {
    mode = Mode.SORT;
    panel = new ShellSortPanel();
}
void changeToQuickSort() {
    mode = Mode.SORT;
    panel = new QuickSortPanel();
}
void drawFrameRate() {
    fill(0);
    strokeWeight(2);
    textSize(50);
    text((int)frameRate,width - 50,50);
}
void setup() {
    size(1000,750);
    frameRate(framerate);
    
    panel = new TitleWindow();
}
void draw() {
    background(litblu);
    
    if (mode == Mode.TITLE) {
        panel.update();
        panel.draw();
    }
    else {
        panel.update();
        panel.draw();
    }
    
    if (drawFrameRateFlag) {
        drawFrameRate();
    }
    if (drawComputingCost) {
        fill(0);
        strokeWeight(2);
        textSize(50);
        textAlign(LEFT,CENTER);
        text((int)countCost,50,50);
    }
}
