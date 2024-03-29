(defun drawBoard ()
  (command "_line" (list 0 0) (list 600 0) "")
  (command "_line" (list 600 0) (list 600 600) "")
  (command "_line" (list 600 600) (list 0 600) "")
  (command "_line" (list 0 600) (list 0 0) "")

  (command "_line" (list 0 200) (list 600 200) "")
  (command "_line" (list 0 400) (list 600 400) "")

  (command "_line" (list 200 0) (list 200 600) "")
  (command "_line" (list 400 0) (list 400 600) "")
)

  (setq l0 (list (list 0 0) (list 0 1) (list 0 2)))
  (setq l1 (list (list 1 0) (list 1 1) (list 1 2)))
  (setq l2 (list (list 2 0) (list 2 1) (list 2 2)))
  (setq l3 (list (list 0 0) (list 1 0) (list 2 0)))
  (setq l4 (list (list 0 1) (list 1 1) (list 2 1)))
  (setq l5 (list (list 0 2) (list 1 2) (list 2 2)))
  (setq l6 (list (list 0 0) (list 1 1) (list 2 2)))
  (setq l7 (list (list 2 0) (list 1 1) (list 0 2)))
	
  (setq scoreList (list l0 l1 l2 l3 l4 l5 l6 l7))

(setq downDraw (list (list 100 100) (list 300 100) (list 500 100)))
(setq middleDraw (list (list 100 300) (list 300 300) (list 500 300)))
(setq upDraw (list (list 100 500) (list 300 500) (list 500 500)))
(setq boardDraw (list downDraw middleDraw upDraw))
(setq boardBtn (list 0 200 400 600))
(setq boardLogic ())

(setq SIGN (list "SGN_CIRCLE" "SGN_CROSS"))
(setq FIELD (list "FLD_EMPTY" "Circle" "_line"))
(setq GAMESTATE (list "GS_NOTSTARTED" "GS_MOVE" "GS_WON" "GS_DRAW"))


(defun draw_circle (Point color)
  (command "_circle" Point 100 color)
)

(defun drawCross (Point)
  
	(setq startTop (list (-(nth 0 Point) 100) (+(nth 1 Point) 100)))
	(setq startDown (list (+ (nth 0 Point) 100) (-(nth 1 Point) 100)))
	(command "_line" startTop startDown "")

	(setq finishDown (list (-(nth 0 Point) 100) (-(nth 1 Point) 100)))
	(setq finishTop (list (+ (nth 0 Point) 100) (+(nth 1 Point) 100)))
	(command "_line" finishDown finishTop "")

  )

(defun drawFigure (input)

  (setq Point (nth 0 input))
  (setq Figure (nth 1 input))

  (if (= Figure "_line")
    (drawCross Point)
    (draw_circle Point)
    )
  )

(defun writeLogic (board xBoard yBoard figure)

  (setq tmpBoard ())
  (setq countY 0)

  (while (< countY 3)
    (setq countX 0)
    (setq freeListTmp ())
    (setq listTmp (nth countY board))
    (while (< countX 3)
      (setq varTmp (nth countX listTmp))
      (if (and (= countY yBoard) (= countX xBoard) )
	(setq freeListTmp (append freeListTmp (list figure)))
	(setq freeListTmp (append freeListTmp (list varTmp)))
	)
      (setq countX (+ 1 countX))
      )
    (setq tmpBoard (append tmpBoard (list freeListTmp)))
  (setq countY (+ 1 countY))
  )
  (setq boardLogic tmpBoard)
 )

(defun checkResult (Figure)
  (setq field nil)
  (setq properField nil)
  (setq numberOfProperField nil)

  (setq count 0)

  (while (< count 8)
    (setq properField "FLD_EMPTY")
    (setq field "FLD_EMPTY")
    (setq numberOfProperField 0)
    (setq countJ 0)
    (while (< countJ 3)
      (setq param1 (nth count scoreList))
      (setq param1 (nth countJ param1))
      (setq param2 (nth 1 param1))
      (setq param1 (nth 0 param1))
      (setq tmpNameField (nth param1 (nth param2 boardLogic)))
      (if (= tmpNameField Figure)
	(setq numberOfProperField (+ numberOfProperField 1))
	)
      (setq countJ (+ countJ 1))
      )
    (if (= numberOfProperField 3)
      (setq gameStage "GS_WON")
      )
    (setq count (+ count 1))
    )
  
  )

(defun moveGame (Figure)
  (print Figure)
  (setq runVar 1)
  (while (> runVar 0)
  	 (setq onClick (getpoint))
	 (setq xClick (nth 0 onClick))
	 (setq yClick (nth 1 onClick))

         (setq tempPoint nil)
  	 (setq count 0)
  
  	 (if(or (> xClick 600) (> yClick 600) (< xClick 0) (< yClick 0))
	  (print "OUT OF BOARD")
	  (while (< count 3)
	    (setq runVar 2)
	    (setq countX 0)
	    (if (and (< yClick (nth (+ count 1) boardBtn)) (> yClick (nth count boardBtn)))
	      (while (< countX 3)
		(if (and (< xClick (nth (+ countX 1) boardBtn)) (> xClick (nth countX boardBtn)))
		  (setq tempPoint(list countX count))
		  )
		(setq countX (+ countX 1))
		)
	      )
	    (setq count (+ count 1))
	    )
	  )
        (while (= runVar 2)
	  (setq Point (nth (nth 1 tempPoint) boardDraw))
	  (setq Point (nth (nth 0 tempPoint) Point))
	  (setq Figure Figure)
	  (if (/= gameStage "GS_MOVE")
	    (setq returnMG 0)
	    )
	  (if (not (and (>= numberField 1) (<= numberField 9)))
	    (setq returnMG 0)
	    )
	  (setq clickedBtnLogic (nth (nth 0 tempPoint) (nth (nth 1 tempPoint) boardLogic)))
	  (if (= clickedBtnLogic "FLD_EMPTY")
	    (setq runVar 0)
	    (setq runVar 1)
	    )
	  (if (= runVar 1)
		(print "NOT EMPTY")
	    )
	  )
    )
  (writeLogic boardLogic (nth 0 tempPoint) (nth 1 tempPoint) curentPlayer)
  (drawFigure (list Point Figure))
 )

(defun startGame ()
(princ "DRAW")
(drawBoard)
  (setq returnVal nil)
	(if (= gameStage "GS_NOTSTARTED")
	  (setq returnVal 2)
	  (setq returnVal 0)
  	)
  (while (= returnVal 2)
    	(setq boardLogic (list (list "FLD_EMPTY" "FLD_EMPTY" "FLD_EMPTY");0
			       (list "FLD_EMPTY" "FLD_EMPTY" "FLD_EMPTY");1
			       (list "FLD_EMPTY" "FLD_EMPTY" "FLD_EMPTY");2
			)
	      )
    	(setq gameStage "GS_MOVE")
	(setq returnVal 1)
    )
)


(setq gameStage "GS_NOTSTARTED")
(setq curentPlayer nil)
(startGame)

(setq gameCount 0)
(while (and (< gameCount 9 )(/= gameStage "GS_WON"))
  (if(= (rem gameCount 2) 0)
    (setq curentPlayer "_line")
    (setq curentPlayer "Circle")
    )
  (moveGame curentPlayer)
  (checkResult curentPlayer)
  (if (= gameStage "GS_WON")
       (alert (strcat "Game over! " curentPlayer " has won!"))
    )
  (setq gameCount (+ 1 gameCount))
)
(if (and (= gameCount 9) (/= gameStage "GS_WON")) 
    (setq gameStage "GS_DRAW")
)
(if (= gameStage "GS_DRAW")
   (alert "Game over! Tie!")
  )


