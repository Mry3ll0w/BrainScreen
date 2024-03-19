/**
 * Modelo Project para interactuar con la base de datos.
 */
class Project {
  /**
     * Constructor de la clase Project.
     * @param {string} alexaUserID Amazon UID of the user to link to the
        project.
     * @param {string} name Project's name to link the user to.
     * @param {Array} members List of members of the project.
     * @param {string} owner Owner of the project.
     */
  constructor(alexaUserID, name, members, owner) {
    this._alexaUserID = alexaUserID;
    this._name = name;
    this._members = members;
    this._owner = owner;
  }
  /**
   * Getter for the alexaUserID property.
   * @return {string} Amazon UID of the user to link to the project.
   */
  get alexaUserID() {
    return this._alexaUserID;
  }
  /**
   * Setter for the alexaUserID property.
   * @param {string} value Amazon UID of the user to link to the project.
   */
  set alexaUserID(value) {
    this._alexaUserID = value;
  }
  /**
     * Getter for the name property.
     * @return {string} Project's name to link the user to.
     */
  get name() {
    return this._name;
  }
  /**
     * Setter for the name property.
     * @param {string} value Project's name to link the user to.
     */
  set name(value) {
    this._name = value;
  }
  /**
     * Getter for the members property.
     * @return {Array} List of members of the project.
     */
  get members() {
    return this._members;
  }
  /**
     * Setter for the members property.
     * @param {Array} value List of members of the project.
     */
  set members(value) {
    if (Array.isArray(value)) {
      this._members = value;
    } else {
      throw new Error('Members must be an array of strings.');
    }
  }
  /**
  * Method to add a member to the project.
  * @param {string} member Member to add to the project.
  */
  addMember(member) {
    if (typeof member === 'string') {
      this._members.push(member);
    } else {
      throw new Error('Member must be a string.');
    }
  }

  /**
     * Getter for the owner property.
     * @return {string} Owner of the project.
     */
  get owner() {
    return this._owner;
  }
  /**
     * Setter for the owner property.
     * @param {string} value Owner of the project.
     */
  set owner(value) {
    this._owner = value;
  }
}

module.exports = Project;
