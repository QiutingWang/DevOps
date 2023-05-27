# YAML Syntax

## References

- Yaml Tutorial | Learn YAML in 18 mins <https://www.youtube.com/watch?v=1uFVr15xDGg>
- What is YAML? The YML File Format. <https://www.freecodecamp.org/news/what-is-yaml-the-yml-file-format/>
- Online YAML Edit Tool. <https://onlineyamltools.com/> 
  - Use it to check whether the yaml codes we wrote are valid.
- Brief YAML reference. <https://camel.readthedocs.io/en/latest/yamlref.html>

## Why YAML?

- widely used format for different DevOps tools
- It is a data serialization language with standard format for transferring data with different data structures and written in different sets of technologies.
  - XML(`<>`), JSON(`{}`,`[]`), YAML are used for creating configuration files and data transfer
  - YAML can do everything which JSON can do and more. JSON ⊆ YAML file, JSON→YAML
  - YAML codes are more clean, readable, and intuitive.
- Stands for *Yaml Ain't Markup Language* 
- YAML codes are written with <u>line separation and indentation</u>.
- Use Cases:
  - Docker Compose File
  - Ansible 
  - Kubernetes

## Syntax of YAML

- Key-Value pairs:
  - values can be different data types: string (with/without "" or '' as well), number, float, boolean(false/true yes/no on/off), null(or ~), timestamp
  - there should be a *space* between : and value
- Comment: symbol `#`
- Object: 
  - on the top of several key-value pairs attributes
  - each attribute should have identical indentation levelly.
- List:
  - under the same object, there exist lists
  - use `-` dash to denote a list
  - lists for single values
  - nested list is allowed
- use `---` at start of each YAML files.
  - YAML allows to contain multiple YAML files in one document, they separate each other with `---` three dash lines.
- use `...` at the end of the whole YAML document.
- Specify data type:
  - `key: !!datatypeName value`
- Multiline Strings:
  - use pipe symbol `|` after the `object: ` unfolds that there are multiline strings as below.
- SingleLine Strings:
  - use `>` symbol after `object: ` to denotes as follow there exist a single long string that lies on multiple lines. 
  - denotes new line symbol `\n`
- Environmental variables:
  - `$EnvVariableName`
- Placeholder:
  - use `{{ }}` 
  - the content in double brackets will be replace by template generator
- YAML files postfix can be .yaml or .yml
- Uppercase and Lowercase are matter. Case sensitive.
  - Apple != apple.
- Anchor: 
  - anchor set to reference code as a note
  - use `key: &anchorName` and `key: *anchorName` for alias name
    - alias means reuse the same value
  - What and where do you want to copy.
- Merge key
  - use `<<`
  - all the keys of one or more specified maps should be inserted into the current map unless the key already exists in it.

