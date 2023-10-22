.model small
.stack 100h
.data
		msg1 db "Please select an action (1-6): $"
		msg2 db "Item			Quantity $"
		msg3 db "Please select an item (1-5): $"
		msg4 db "Please insert the number of stock  (0-9): $"
		msg5 db "Invalid / Maximum 9 stocks can be stored due to space limitation $"
		msg6 db "Invalid / Negative stocks $"
		msg7 db "Invalid Item Choosen $"
		space db "		 $"
		
		system db "Inventory Management System $"

        menu1 db "1.List all items $"
        menu2 db "2.List finished items $"
        menu3 db "3.List items need to be ordered $"
        menu4 db "4.Add stock $"
        menu5 db "5.Deduct stock $"
        menu6 db "6.Exit $"

        item1 db "1.Mouse $"
        stock1 db "7 $"
        item2 db "2.Keyboard $"
        stock2 db "3 $"
        item3 db "3.Graphic Card $"
        stock3 db "6 $"
        item4 db "4.Monitor $"
        stock4 db "1 $"
        item5 db "5.CPU 	$"
        stock5 db "0 $"
.code

showMenu MACRO x ;Main Menu
        mov ah,09
        mov dx,offset x
        int 21h

        mov ah,02
        mov dl,10
        int 21h
Endm

navigateMenu MACRO userChoice
	cmp userChoice, '1'
	jne notMenu1
	jmp displayAllItems
	
	notMenu1:
	cmp userChoice, '2'
	jne notMenu2
	jmp displayFinishedItems
	
	notMenu2:
	cmp userChoice, '3'
	jne notMenu3
	jmp displayItemsToOrder
	
	notMenu3:
	cmp userChoice, '4'
	jne notMenu4
	jmp increase
	
	notMenu4:
	cmp userChoice, '5'
	jne notMenu5
	jmp deduct
	
	notMenu5:
	mov ah,4ch
	int 21h
Endm

showItemListTitle MACRO
	mov ah,02
	mov dl,10
    int 21h
	mov ah,09
	mov dx,offset msg2
	int 21h
Endm

showItemList MACRO y, z
	mov ah,02
	mov dl,10
	int 21h
	mov ah,09
	mov dx,offset y
	int 21h
	mov dx,offset space
	int 21h
	mov dx,offset z
	int 21h
Endm

addDeductSelection MACRO 
	mov ah, 02
    mov dl, 10
    int 21h

    mov ah, 09
    mov dx, offset msg3
    int 21h

    ; Read the item
    mov ah, 01
    int 21h
Endm

insertStock MACRO 
	mov ah,02		
	mov dl,10
	int 21h 
	
	mov ah,09
	mov dx,offset msg4
	int 21h
	
	mov ah, 01
	int 21h
	sub al, '0'	
Endm

addStock MACRO stock
	add stock, al
	jmp menu
Endm

minusStock MACRO stock
	sub stock, al
	jmp menu
Endm

validationIncreaseStock MACRO stock ;Check added stock more than 9
	mov bl, stock
    add bl, al
	cmp bl, '9'
Endm

validationDecreaseStock MACRO stock ;Check deducted stock less than 0
	mov bl, stock
    sub bl, al
	cmp bl, '0'
Endm

checkFinishedItem MACRO stock ;Check item = 0
	mov bl, stock
	cmp bl, '0'
Endm

checkItemsOrder MACRO stock ;Check item < 5
	mov bl, stock
	cmp bl, '5'
Endm

;Highlight item quantity less than 5
colorCode MACRO y,z 
	mov ah,02
	mov dl,10
	int 21h
	
	;Highlight item
	mov ah,09
	mov bl,195
	mov cx,14
	int 10h
	mov dx,offset y
	int 21h
	
	mov dx,offset space
	int 21h
	
	;Highlight stock
	mov bl,195
	mov cx,1
	int 10h
	mov dx,offset z
	int 21h

Endm

MAIN PROC                     
        mov ax,@data
        mov ds,ax

menu:
	
		mov ah,02		
        mov dl,10
        int 21h 
		
		;Title Style
		mov ah,09
		mov bl,8ah
		mov cx,27
		int 10h
		
        mov dx,offset system
        int 21h

		mov ah, 02
		mov dl, 10
		int 21h
		
        showMenu menu1
        showMenu menu2
        showMenu menu3
        showMenu menu4
        showMenu menu5
        showMenu menu6

		mov ah,09
        mov dx,offset msg1
        int 21h

		;User Choice
		mov ah,01
		int 21h 
		
		;Validate User Choice
		cmp al, '1'
		jb menu
		cmp al, '6'
		ja menu
		navigateMenu al

displayAllItems: ;Show All Items
		showItemListTitle
		checkItemsOrder stock1
		jb highlightItem1
		showItemList item1, stock1
		jmp validateHighlightItem2
		
	highlightItem1:
		colorCode item1,stock1
		jmp validateHighlightItem2
	
	highlightItem2:
		colorCode item2,stock2
		jmp validateHighlightItem3
	
	validateHighlightItem2:
		checkItemsOrder stock2
		jb highlightItem2
		showItemList item2, stock2
		jmp validateHighlightItem3
		
	highlightItem3:
		colorCode item3,stock3
		jmp validateHighlightItem4
		
	validateHighlightItem3:
		checkItemsOrder stock3
		jb highlightItem3
		showItemList item3, stock3
		jmp validateHighlightItem4
	
	highlightItem4:
		colorCode item4,stock4
		jmp validateHighlightItem5
	
	validateHighlightItem4:
		checkItemsOrder stock4
		jb highlightItem4
		showItemList item4, stock4
		jmp validateHighlightItem5
		
	highlightItem5:
		colorCode item5,stock5
		jmp menu
		
	validateHighlightItem5:
		checkItemsOrder stock5
		jb highlightItem5
		showItemList item5, stock5
		jmp menu

displayFinishedItems: ;Show finished items
		showItemListTitle
		checkFinishedItem stock1
		je finishedItem1
		jmp validateFinishedItem2
		
	finishedItem1:
		showItemList item1, stock1
		jmp validateFinishedItem2
		
	finishedItem2:
		showItemList item2, stock2
		jmp validateFinishedItem3
	
	validateFinishedItem2:
		checkFinishedItem stock2
		je finishedItem2
		jmp validateFinishedItem3
		
	finishedItem3:
		showItemList item3, stock3
		jmp validateFinishedItem4
		
	validateFinishedItem3:
		checkFinishedItem stock3
		je finishedItem3
		jmp validateFinishedItem4
	
	finishedItem4:
		showItemList item4, stock4
		jmp validateFinishedItem5
	
	validateFinishedItem4:
		checkFinishedItem stock4
		je finishedItem4
		jmp validateFinishedItem5
		
	finishedItem5:
		showItemList item5, stock5
		jmp menu
		
	validateFinishedItem5:
		checkFinishedItem stock5
		je finishedItem5
		jmp menu

displayItemsToOrder: ;SHow Items Quantity Less Than 5  
		showItemListTitle
		checkItemsOrder stock1
		jb orderItem1
		jmp validateOrderItem2
		
	orderItem1:
		showItemList item1, stock1
		jmp validateOrderItem2
	
	orderItem2:
		showItemList item2, stock2
		jmp validateOrderItem3
	
	validateOrderItem2:
		checkItemsOrder stock2
		jb orderItem2
		jmp validateOrderItem3
		
	orderItem3:
		showItemList item3, stock3
		jmp validateOrderItem4
		
	validateOrderItem3:
		checkItemsOrder stock3
		jb orderItem3
		jmp validateOrderItem4
	
	orderItem4:
		showItemList item4, stock4
		jmp validateOrderItem5
	
	validateOrderItem4:
		checkItemsOrder stock4
		jb orderItem4
		jmp validateOrderItem5
		
	orderItem5:
		showItemList item5, stock5
		jmp menu
		
	validateOrderItem5:
		checkItemsOrder stock5
		jb orderItem5
		jmp menu
		
increase: ;Add Stock
		showItemListTitle
		showItemList item1, stock1
		showItemList item2, stock2
		showItemList item3, stock3
		showItemList item4, stock4
		showItemList item5, stock5
		
		addDeductSelection
		
		;Validate User Item Choice
		cmp al, '1'
		jb validateAddItem
		cmp al, '5'
		ja validateAddItem
		
		cmp al, '1'
		jne notAddItem1
		jmp addItem1
		
	validateAddItem:
		jmp menu
		
	notAddItem1:
		cmp al, '2'
		jne notAddItem2
		jmp addItem2

	notAddItem2:
		cmp al, '3'
		jne notAddItem3
		jmp addItem3

	notAddItem3:
		cmp al, '4'
		jne notAddItem4
		jmp addItem4

	notAddItem4:
		jmp addItem5
	
	addItem1:
		insertStock 
		validationIncreaseStock stock1
		ja validateAddStock
		addStock stock1

	addItem2:
		insertStock 
		validationIncreaseStock stock2
		ja validateAddStock
		addStock stock2
		
	validateAddStock: ;Validation for Adding Stock
		mov ah,02		
		mov dl,10
		int 21h 
		mov ah,09
		mov dx, offset msg5
		int 21h
		jmp menu
		
	addItem3:
		insertStock 
		validationIncreaseStock stock3
		ja validateAddStock
		addStock stock3
		
	addItem4:
		insertStock 
		validationIncreaseStock stock4
		ja validateAddStock
		addStock stock4
		
	addItem5:
		insertStock 
		validationIncreaseStock stock5
		ja validateAddStock
		addStock stock5
	
deduct: ;Minus Stock
	showItemListTitle
    showItemList item1, stock1
    showItemList item2, stock2
    showItemList item3, stock3
    showItemList item4, stock4
    showItemList item5, stock5

    addDeductSelection 
	
	;Validate User Item Choice
	cmp al, '1'
	jb validateDeductItem
	cmp al, '5'
	ja validateDeductItem

    cmp al, '1'
    jne notDeductItem1
    jmp deductItem1

	validateDeductItem:
		jmp menu

    notDeductItem1:
        cmp al, '2'
        jne notDeductItem2
        jmp deductItem2

    notDeductItem2:
        cmp al, '3'
        jne notDeductItem3
        jmp deductItem3

    notDeductItem3:
        cmp al, '4'
        jne notDeductItem4
        jmp deductItem4

    notDeductItem4:
        cmp al, '5'
        jmp deductItem5

    deductItem1:
		insertStock
		cmp al, 0
		jb validateDeductStock
		cmp al, 9
		ja validateDeductStock	
		validationDecreaseStock stock1
		jb validateDeductStock
		minusStock stock1   
		
	deductItem2:
		insertStock 
		cmp al, 0
		jb validateDeductStock
		cmp al, 9
		ja validateDeductStock	
		validationDecreaseStock stock2
		jb validateDeductStock
		minusStock stock2
		
	validateDeductStock:
		mov ah,02		
		mov dl,10
		int 21h 
		mov ah,09
		mov dx, offset msg6
		int 21h
		jmp menu
	
	deductItem3:
		insertStock 
		cmp al, 0
		jb validateDeductStock
		cmp al, 9
		ja validateDeductStock	
		validationDecreaseStock stock3
		jb validateDeductStock
		minusStock stock3
	
	deductItem4:
		insertStock 
		cmp al, 0
		jb validateDeductStock
		cmp al, 9
		ja validateDeductStock	
		validationDecreaseStock stock4
		jb validateDeductStock
		minusStock stock4
		
	deductItem5:
		insertStock 
		cmp al, 0
		jb validationJump
		cmp al, 9
		ja validationJump	
		validationDecreaseStock stock5
		jb validationJump
		minusStock stock5
	
	validationJump: ; Jump Statement To Validate Deduct Stock Due To Jump Out Of Range in deductItem5
		jmp validateDeductStock
		
	
Main endp
End main