using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateLevel : MonoBehaviour
{
    public float corridorWidth = 2.0f;
    public float North = 10.0f;
    public GameObject wallSection;
    private enum Wall { none, vertical, horizontal };

    // Start is called before the first frame update
    void Start()
    {
        CreateMazeObjects();
    }

    // Update is called once per frame
    void Update()
    {

    }

    Wall[,] GenerateWallArray()
    {
        // Aspect ratio of map is 16:10, so we will use 16 spaces wide and 10 spaces high
        // We're in terms of rows/columns here so its backwards from width/height
        // this array will be initialized as all false
        Wall[,] hasWall = new Wall[10, 16];
        // Set entire top row to true, representing that there are walls there
        for (int i = 0; i < hasWall.GetLength(1); i++)
        {
            hasWall[0, i] = Wall.horizontal;
        }
        return hasWall;
    }

    void CreateMazeObjects()
    {
        Wall[,] walls = GenerateWallArray();
        for (int i = 0; i < walls.GetLength(0); i++)
        {
            for (int j = 0; j < walls.GetLength(1); j++)
            {
                if (walls[i, j] != Wall.none)
                {
                    CreateWallSegment(i, j, walls[i, j]);
                }
            }
        }
    }

    void CreateWallSegment(float row, float column, Wall wall)
    {
        GameObject newSection = Instantiate(wallSection);
        float xScale = 1.0f;
        float zScale = 1.0f;
        Vector3 positionBeforeScaling = new Vector3(column, 0.5f, North - row);

        if (wall == Wall.horizontal)
        {
            xScale = 2.0f;
            zScale = 0.5f;
        }
        else
        {
            xScale = 0.5f;
            zScale = 2.0f;
        }
        newSection.transform.localScale = new Vector3(xScale, 0.5f, zScale);
        Vector3 finalPosition = new Vector3(positionBeforeScaling.x + xScale*1, positionBeforeScaling.y, positionBeforeScaling.z + zScale);

        newSection.transform.position = finalPosition;
        Debug.Log($"Adding {wall.ToString()} wall at {finalPosition.x},{finalPosition.y},{finalPosition.z}");
    }


}
