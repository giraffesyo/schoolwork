using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReferenceHolder : MonoBehaviour
{
    // we are making a private _instance and public instance that only has a getter
    // effectively making sure only one of these ever gets created (singleton)
    // still would cause problems if there were multiple reference holders added to scene, so lets not do that
    private static ReferenceHolder _instance;
    public static ReferenceHolder instance
    {
        get
        {
            if(_instance == null)
            {
                // get reference to our game object and set it as our private _instance variable
                _instance = FindObjectOfType<ReferenceHolder>();
                // if its still null that means there wasn't a reference holder object in the scene
                if(_instance == null)
                {
                    // log this out to console
                    Debug.LogError("No reference holder in the scene");
                }
            } 
            // return reference to the private _instance
            return _instance;
        }
    }
    public Canvas canvas;
}
