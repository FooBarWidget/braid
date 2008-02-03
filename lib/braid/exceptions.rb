module Braid
  class Exception < StandardError
  end

  module Commands
    class LocalRevisionIsHigherThanRequestedRevision < Braid::Exception; end
    class MirrorAlreadyUpToDate < Braid::Exception; end
    class RequestedRevisionIsHigherThanRemoteRevision < Braid::Exception; end
  end

  class Config
    class MirrorNameAlreadyInUse < Braid::Exception; end
    class MirrorDoesNotExist < Braid::Exception; end
  end

  class Svn
    class TargetDirectoryAlreadyExists < Braid::Exception; end
    class RepositoryNotFound < Braid::Exception; end
  end

  class Git
    class LocalRepositoryHasUncommitedChanges < Braid::Exception; end
    class RepositoryError < Braid::Exception; end
  end
end
