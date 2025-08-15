

list<public>(t:type) := class:
    Data<public>:t
    Next<public>:?list(t)

queue<public>(t:type) := class<internal>:
    Elements<internal>:?list(t) = false
    Size<public>:int = 0

    Enqueue<public>(NewElement:t):queue(t) =
        queue(t):
            Elements := option:
                list(t):
                    Data := NewElement
                    Next := Elements
            Size := Size + 1

    Dequeue<public>()<decides><transacts>:tuple(queue(t), t) =
        List := Elements?
        (queue(t){Elements := List.Next, Size := Size - 1}, List.Data)

    Front<public>()<decides><transacts>:t = Elements?.Data

CreateQueue<public><constructor>(InData:t where t:type) := queue(t):
    Elements := option:
        list(t):
            Data := InData
            Next := false
    Size := 1