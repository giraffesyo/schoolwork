using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class childrenAppearRandomly : MonoBehaviour
{
    // the amount of time until another unit appears 
    public static float timeBetweenAppearances = 6.0f;
    public static float timeAlive = timeBetweenAppearances - 1;
    // maximum left location
    public float maxLeft = -2.9f;
    // maximum right location
    public float maxRight = 3.48f;

    // time since last appearance
    private float timeSinceLastAppearance;
    // curent child that is spawned
    private int nextChildPrefabIndex = 0;
    private int maxChildPrefabIndex;
    private GameObject currentChild;


    // Start is called before the first frame update
    void Start()
    {
        // Store the initial number of children, which are the prefabs we'll use
        maxChildPrefabIndex = this.transform.childCount;
        // create our first instance to get this started off
        currentChild = createInstanceOfChild();
        // we spawn the initial child so we should start our timer
        timeSinceLastAppearance = 0;
    }

    // Update is called once per frame
    void Update()
    {
        timeSinceLastAppearance += Time.deltaTime;

        if (timeSinceLastAppearance > timeBetweenAppearances)
        {
            Destroy(currentChild);
            currentChild = createInstanceOfChild();
            timeSinceLastAppearance = 0;
        }

    }

    float chooseRandomX()
    {
        return Random.Range(maxLeft, maxRight);
    }


    GameObject createInstanceOfChild()
    {
        // get the prefab for the next child to be spawned
        GameObject nextPrefab = transform.GetChild(this.nextChildPrefabIndex).gameObject;
        //set the position to a new random x value, maintaining y and z
        transform.position = new Vector3(chooseRandomX(), transform.position.y, transform.position.z);
        // instantiate a copy of the child
        GameObject newChild = Instantiate(nextPrefab, transform);
        // attach riseAboveGround.cs script to new child
        newChild.AddComponent<riseAboveGround>();
        // Increment our counter so we get a new prefab each time this function is called
        // if we have run out of prefabs then go back to 0 and start again (in a way we're imitating a generator)
        if (this.nextChildPrefabIndex + 1 >= maxChildPrefabIndex)
        {
            this.nextChildPrefabIndex = 0;
        }
        else
        {
            this.nextChildPrefabIndex++;
        }
        return newChild;
    }
}