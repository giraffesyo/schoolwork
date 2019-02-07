using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class destroyAfter : MonoBehaviour
{

    private float timeSinceSpawned = 0.0f;
    public float aliveForSeconds = 1.0f;
    private int renderedFrames = 0;
    private Renderer rend;

    private void Start()
    {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        timeSinceSpawned += Time.deltaTime;
        if (timeSinceSpawned > aliveForSeconds)
        {
            Destroy(this.gameObject);
        }

        // blink every 5 frames
        if(renderedFrames == 5)
        {
            renderedFrames = 0;
            // flip rendered
            rend.enabled = !rend.enabled;
        }
        renderedFrames++;
    }
}
