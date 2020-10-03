//Stack implementation using static array

#include<stdio.h>
#define CAPACITY 5  //Pre-processor macro   and  change the size if you want
int stack[CAPACITY], top=-1 ;

void push(int);
int pop(void);
int isFull(void);
int isEmpty(void);
void traverse(void);
void peek(void);

void main()
{
    char ch;
    long int item;
    while(1)
    {
        printf("\n ---------------------- \n 1.Push an element \n 2.PoP element\n 3.Peek \n 4.Traverse\n 5.Quit \n ---------------------- \n");
        printf("Enter your choice:");
        scanf("%d",&ch);

        switch(ch)
        {
            case 1:
                printf("\nEnter element to push:");
                scanf("%d",&item);
                push(item);
                break;
            case 2: item = pop();
                    if(item==0)
                    {
                        printf("Stack is underflow\n");
                    }
                    else
                    {
                        printf("Popped item: %d\n",item);
                    }
                    break;
            case 3:     peek();
                        break;
            case 4:     traverse();
                        break;
            case 5:     exit(0);
            default:    printf("Invalid input\n\n");
                        break;
        }
    }

}
int isFull()
{
    if(top== CAPACITY-1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
int isEmpty()
{
    if(top==-1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
void push(int ele)
{
    if(isFull())
    {
        printf("\n Stack is overflow...\n");
    }
    else
    {
        top++;
        stack[top] = ele;
        printf("\n %d pushed into stack \n", ele);
    }
}

int pop()
{
    if(isEmpty())
    {
        return 0;
    }
    else
    {
        return stack[top--];
    }
}
void peek()
{
    if(isEmpty())
    {
        printf("\nStack is empty \n");
    }
    else
    {
        printf("\n Peek element: %d \n",stack[top]);
    }
}
void traverse()
{
    if(isEmpty())
    {
        printf("\n Stack is empty \n");
    }
    else
    {
        int i;
        printf("\n Stack elements : \n");
        for(i=0;i<=top;i++)
        {
            printf("%d\n________________ \n",stack[i]);
        }
    }
}
