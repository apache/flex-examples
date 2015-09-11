package
{
    public class Product
    {
        public function Product(data:Object)
        {
            this.data = data;
        }
        
        private var data:Object;
        
        public function get name():String
        {
            return data.name;    
        }
        
        public function get description():String
        {
            return data.description;    
        }

        public function get archiveURL():String
        {
            return data.archiveURL;    
        }

        public function get archivePattern():String
        {
            return data.archivePattern;    
        }
        
        public function get releasePattern():String
        {
            return data.releasePattern;    
        }
        
        public function get releaseURL():String
        {
            return data.releaseURL;    
        }
        
        public function get excludes():Array
        {
            return data.excludes;    
        }
        
        public function get releases():Array
        {
            return data.releases;    
        }
        public function set releases(value:Array):void
        {
            data.releases = value;    
        }
    }
}