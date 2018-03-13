--------------------------------------------------------------------------------
-- Parent/Child hierarchy CTE
--
-- Traverse a tree from root to find all children and their level
--------------------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Hierarchy' AND type = 'U')
BEGIN
	DROP TABLE Hierarchy
END
CREATE TABLE Hierarchy
(
	 ParentID VARCHAR(250)
	,ChildID VARCHAR(250)
)

INSERT INTO Hierarchy VALUES ('Root', 'Level1Node1')
INSERT INTO Hierarchy VALUES ('Root', 'Level1Node2')
INSERT INTO Hierarchy VALUES ('Level1Node1', 'Level2Node1Child1')
INSERT INTO Hierarchy VALUES ('Level1Node1', 'Level2Node1Child2')
INSERT INTO Hierarchy VALUES ('Level1Node1', 'Level2Node1Child3')
INSERT INTO Hierarchy VALUES ('Level2Node1Child1', 'Level3Node1Child1Child1')
INSERT INTO Hierarchy VALUES ('Level2Node1Child2', 'Level3Node1Child2Child1')
INSERT INTO Hierarchy VALUES ('Level2Node1Child2', 'Level3Node1Child2Child2')
INSERT INTO Hierarchy VALUES ('Level3Node1Child2Child2', 'Level3Node1Child2Child2Child1')
;

-- Use a recursive CTE to continue down the tree
WITH asset_tree AS
(
	SELECT
		 par.ParentID
		,par.ChildID
		,1 AS TreeLevel
	FROM
		Hierarchy par
	WHERE
		par.ParentID NOT IN (SELECT ChildID FROM Hierarchy)
	UNION ALL
	SELECT
		 child.ParentID
		,child.ChildID
		,par.TreeLevel + 1 AS TreeLevel
	FROM
		asset_tree par
		INNER JOIN Hierarchy child
			ON par.ChildID = child.ParentID
)
SELECT * FROM asset_tree
