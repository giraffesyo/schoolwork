using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateLevel : MonoBehaviour
{
    public float corridorWidth = 2.0f;
    public float North = 10.0f;
    public float West = -15.0f;
    public GameObject wallSection;

    // Aspect ratio of map is 16:10, so we will use 32 spaces wide and 20 spaces high to deal with the different orientations the stretched cubes can have
    // We're in terms of rows/columns here so its backwards from width/height
    private Vector2Int size = new Vector2Int(20, 32);

    // Start is called before the first frame update
    void Start()
    {
        CreateMazeObjects();
    }

    // Update is called once per frame
    void Update()
    {

    }

    bool[,] GenerateWallArray()
    {
        // this array will be initialized as all false
        bool[,] hasWall = new bool[size.x, size.y];
        // Set edges of maze to have walls all the way around
        for (int i = 0; i < size.y; i++)
        {
            hasWall[0, i] = true;
            hasWall[size.x - 1, i] = true;
        }
        for (int i = 0; i < size.x; i++)
        {
            hasWall[i, 0] = true;
            hasWall[i, size.y - 1] = true;
        }

        // Create vertical bar 3 spaces down starting at 3,3
        addVerticalBar(new Vector2Int(3, 3), 3, ref hasWall);

        // Vertical bar below previous, 3 spaces down starting at 8,3
        addVerticalBar(new Vector2Int(8, 3), 3, ref hasWall);

        // Vertical bar 5 spaces down starting at 0,6
        addVerticalBar(new Vector2Int(0, 6), 6, ref hasWall);

        // Horizontal bar at <6,3> 9 spaces wide
        addHorizontalBar(new Vector2Int(6, 3), 9, ref hasWall);

        // Horizontal bar above previous one
        addHorizontalBar(new Vector2Int(3, 9), 3, ref hasWall);


        return hasWall;
    }

    void addVerticalBar(Vector2Int at, int length, ref bool[,] hasWall)
    {
        for (int x = at.x; x < at.x + length; x++)
        {
            hasWall[x, at.y] = true;
        }
    }

    void addHorizontalBar(Vector2Int at, int length, ref bool[,] hasWall)
    {
        for (int y = at.y; y < at.y + length; y++)
        {
            hasWall[at.x, y] = true;
        }
    }
    void CreateMazeObjects()
    {
        bool[,] walls = GenerateWallArray();
        for (int i = 0; i < walls.GetLength(0); i++)
        {
            for (int j = 0; j < walls.GetLength(1); j++)
            {
                if (walls[i, j])
                {
                    CreateWallSegment(i, j);
                }
            }
        }
    }

    void CreateWallSegment(float row, float column)
    {
        GameObject newSection = Instantiate(wallSection);
        Vector3 finalPosition = new Vector3(West + column, 0.5f, North - row);
        newSection.transform.position = finalPosition;
        Debug.Log($"Adding  wall at {finalPosition.x},{finalPosition.y},{finalPosition.z}");
    }


}
