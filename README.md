# Pathfinding Algorithm

```pseudocode
BEGIN

IF currentNode.level != destinationNode.level:
    Destination is not on same level
    SET current destinationNode to a temp variable
    SET destinationNode to nearestLift

IF currentNode == destinationNode:
    We have reached the lift node

SET all nodes heuristic to 999999
ADD all nodes to priority queue

WHILE currentNode != destinationNode OR we have reached the lift:

    IF destination is not on same level and we have reached the lift:

        SET original destinationNode from temp variable
        ADD currentNode to expanded list
        REMOVE currentNode from priority queue
        SET currentNode to nextLevelLift node
        We are now on the same level as destination
    ELSE:
        FOR each neighbour in currentNode:
            IF neighbour not expanded yet:
                Update neighbour’s heuristic
                IF neighbour has not been visited OR previous distance to neighbour is longer than current distance to neighbour:
                    SET neighbour's fromNode to currentNode
                    UPDATE neighbour's distance to shorter distance
                Update neighbour's f-value

        ADD neighbour to expanded list
        REMOVE neighbour from priority queue
        SORT priority list based on f-value
        SET currentNode to first node in queue

        IF we are at the liftNode && destination not on same level:
            We have reached the lift

ADD destinationNode to expandedNode
WHILE destinationNode != startingNode:
    ADD destinationNode to pathArray
    SET destinationNode to destinationNode.fromNode
ADD startingNode to pathArray
REVERSE pathArray to get path from start to destination

END
```
